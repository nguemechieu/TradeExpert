#property strict 

// ---------------------------------------------------------------------
// This code can either create an EA or a script. To create a script,
// comment out the line below. The code will then have OnTimer() 
// and OnTick() instead of OnStart()
// ---------------------------------------------------------------------

#define COMPILE_AS_EA


// ---------------------------------------------------------------------
// If we are compiling as a script, then we want the script
// to display the inputs page
// ---------------------------------------------------------------------

#ifndef COMPILE_AS_EA
#property show_inputs
#endif


// ---------------------------------------------------------------------
// User-configurable parameters
// ---------------------------------------------------------------------

input int PortNumber = 3306; // TCP/IP port number

// ---------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------

// Size of temporary buffer used to read from client sockets
#define SOCKET_READ_BUFFER_SIZE  10000

// Defines the frequency of the main-loop processing, in milliseconds.
// This is either the duration of the sleep in OnStart(), if compiled
// as a script, or the frequency which is given to EventSetMillisecondTimer()
// if compiled as an EA
#define SLEEP_MILLISECONDS       10


// ---------------------------------------------------------------------
// Forward definitions of classes
// ---------------------------------------------------------------------

// Wrapper around a connected client socket
class Connection;

// ---------------------------------------------------------------------
// Winsock structure definitions and DLL imports
// ---------------------------------------------------------------------

struct sockaddr_in {
   short af_family;
   short port;
   int addr;
   int dummy1;
   int dummy2;
};

struct timeval {
   int secs;
   int usecs;
};

struct fd_set {
   int count;
   int single_socket;
   int dummy[63];
};

#import "Ws2_32.dll"
   int socket(int, int, int);   
   int bind(int, sockaddr_in&, int);
   int htons(int);
   int listen(int, int);
   int accept(int, int, int);
   int closesocket(int);
   int select(int, fd_set&, int, int, timeval&);
   int recv(int, uchar&[], int, int);
   int ioctlsocket(int, uint, uint&);
   int WSAGetLastError();
   int WSAAsyncSelect(int, int, uint, int);
#import   


// ---------------------------------------------------------------------
// Global variables
// ---------------------------------------------------------------------

// Flags whether OnInit was successful
bool SuccessfulInit = false;

// Handle of main listening server socket
int ServerSocket;

// List of currently connected clients
Connection * Clients[];

// For EA compilation only, we track whether we have 
// successfully created a timer
#ifdef COMPILE_AS_EA
bool CreatedTimer = false;   
#endif

// ---------------------------------------------------------------------
// Initialisation - create listening socket
// ---------------------------------------------------------------------

void OnInit()
{
   SuccessfulInit = false;
   
   if (!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) {Print("Requires \'Allow DLL imports\'");return;}
   
   // (Don't need to call WSAStartup because MT4 must have done this)

   // Create the main server socket
   ServerSocket = socket(2 /* AF_INET */, 1 /* SOCK_STREAM */, 6 /* IPPROTO_TCP */);
   if (ServerSocket == -1) {Print("ERROR " , WSAGetLastError() , " in socket creation");return;}
   
   // Put the socket into non-blocking mode
   uint nbmode = 1;
   if (ioctlsocket(ServerSocket, 0x8004667E /* FIONBIO */, nbmode) != 0) {Print("ERROR in setting non-blocking mode on server socket");return;}
   
   // Bind the socket to the specified port number. In this example,
   // we only accept connections from localhost
   sockaddr_in service;
   service.af_family = 2 /* AF_INET */;
   service.addr = 0x100007F; // equivalent to inet_addr("127.0.0.1")
   service.port = (short)htons(PortNumber);
   if (bind(ServerSocket, service, 16 /* sizeof(service) */) == -1) {Print("ERROR " , WSAGetLastError() , " in socket bind");return;}

   // Put the socket into listening mode
   if (listen(ServerSocket, 10) == -1) {Print("ERROR " , WSAGetLastError() , " in socket listen");return;}

   #ifdef COMPILE_AS_EA
   // In the context of an EA, we can improve the latency even further by making the 
   // processing event-driven, rather than just on a timer. If we use
   // WSAAsyncSelect() to tell Windows to send a WM_KEYDOWN whenever there's socket
   // activity, then this will fire the EA's OnChartEvent. We can thus collect
   // socket events even faster than via the timed check, which becomes a back-up.
   // Note that WSAAsyncSelect() on a server socket also automatically applies 
   // to all client sockets created from it by accept(), and also that
   // WSAAsyncSelect() puts the socket into non-blocking mode, duplicating what
   // we have already done above using ioctlsocket()
   if (WSAAsyncSelect(ServerSocket, (int)ChartGetInteger(0, CHART_WINDOW_HANDLE), 0x100 /* WM_KEYDOWN */, 0xFF /* All events */) != 0) {
      Print("ERROR " , WSAGetLastError() , " in async select");
   }
   #endif

   // Flag that we've successfully initialised
   SuccessfulInit = true;

   // If we're operating as an EA rather than a script, then try setting up a timer
   #ifdef COMPILE_AS_EA
   CreateTimer();
   #endif   
}


// ---------------------------------------------------------------------
// Variation between EA and script, depending on COMPILE_AS_EA above.
// Both versions simply call MainLoop() to handle the socket activity.
// The script version simply does so from a loop in OnStart().
// The EA version sets up a timer, and then calls MainLoop from OnTimer().
// It also has event-driven handling of socket activity by getting
// Windows to simulate keystrokes whenever a socket event happens.
// This is even faster than relying on the timer.
// ---------------------------------------------------------------------

#ifdef COMPILE_AS_EA
   // .........................................................
   // EA version. Simply calls MainLoop() from a timer.
   // The timer has previously been created in OnInit(), 
   // though we also check this in OnTick()...
   void OnTimer()
   {
      MainLoop();
   }
   
   // The function which creates the timer if it hasn't yet been set up
   void CreateTimer()
   {
      if (!CreatedTimer) CreatedTimer = EventSetMillisecondTimer(SLEEP_MILLISECONDS);
   }

   // Timer creation can sometimes fail in OnInit(), at least
   // up until MT4 build 970, if MT4 is starting up with the EA already
   // attached to a chart. Therefore, as a fallback, we also 
   // handle OnTick(), and thus eventually set up the timer in
   // the EA's first tick if we failed to set it up in OnInit()
   void OnTick()
   {
      CreateTimer();
   }

   // In an EA, the use of WSAAsyncSelect() above means that Windows will fire a key-down 
   // message whenever there is socket activity. We can then respond to KEYDOWN events
   // in MQL4 as a way of knowing that there is socket activity to be dealt with.
   void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
   {
      if (id == CHARTEVENT_KEYDOWN) {
         // The lparam will be the socket handle, and the dparam will be the type
         // of socket event (e.g. dparam = 1 = FD_READ). The fastest option would be
         // to use the socket handle in lparam to identify the specific socket
         // which requires action, but we'll take the slightly less efficient but simpler
         // route where we just do all our full socket handling in response to an event.
         // Similarly, we won't bother to distinguish between real keypresses and 
         // the pseudo-keypresses from WSAAyncSelect().
         MainLoop();   
      }
   }
  
#else

   // .........................................................
   // Script version. Simply calls MainLoop() repeatedly
   // until the script is removed, with a small sleep between calls
   void OnStart()
   {
      while (!IsStopped()) {
         MainLoop();
         Sleep(SLEEP_MILLISECONDS);
      }
   }
#endif


// ---------------------------------------------------------------------
// Main processing loop which handles new incoming connections, and reads
// data from existing connections.
// Can either be called from OnStart() in a script, on a continuous loop 
// until IsStopped() is true; or from OnTimer() in an EA.
// ---------------------------------------------------------------------

void MainLoop()
{
   // Do nothing if init was unsuccessful
   if (!SuccessfulInit) return;
   
   // .........................................................
   // Do we have a new pending connection on the server socket?
   timeval waitfor;
   waitfor.secs = 0;
   waitfor.usecs = 0;
   
   fd_set PollServerSocket;
   PollServerSocket.count = 1;
   PollServerSocket.single_socket = ServerSocket;

   int selres = select(0, PollServerSocket, 0, 0, waitfor);
   if (selres > 0) {
   
      Print("New incoming connection...");
      int NewClientSocket = accept(ServerSocket, 0, 0);
      if (NewClientSocket == -1) {
         if (WSAGetLastError() == 10035 /* WSAEWOULDBLOCK */) {
            // Blocking warning; ignore
         } else {
            Print("ERROR " , WSAGetLastError() , " in socket accept");
         }

      } else {
         Print("...accepted");

         int ctarr = ArraySize(Clients);
         ArrayResize(Clients, ctarr + 1);
         Clients[ctarr] = new Connection(NewClientSocket);               
         Print("Got connection to client #", Clients[ctarr].GetID());
      }
   }

   // .........................................................
   // Process any incoming data from client connections
   // (including any which have just been accepted, above)
   int ctarr = ArraySize(Clients);
   for (int i = ctarr - 1; i >= 0; i--) {
      // Return value from ReadAnyPendingData() is true
      // if the socket still seems to be alive; false if 
      // the connection seems to have been closed, and should be discarded
      if (Clients[i].ReadAnyPendingData()) {
         // Socket still seems to be alive
         
      } else {
         // Socket appears to be dead. Delete, and remove from list
         Print("Lost connection to client #", Clients[i].GetID());
         
         delete Clients[i];
         for (int j = i + 1; j < ctarr; j++) {
            Clients[j - 1] = Clients[j];
         }
         ctarr--;
         ArrayResize(Clients, ctarr);           
      }
   }
}

// ---------------------------------------------------------------------
// Termination - clean up sockets
// ---------------------------------------------------------------------

void OnDeinit(const int reason)
{
   closesocket(ServerSocket);
   
   for (int i = 0; i < ArraySize(Clients); i++) {
      delete Clients[i];
   }
   ArrayResize(Clients, 0);
   
   #ifdef COMPILE_AS_EA
   EventKillTimer();
   CreatedTimer = false;
   #endif
}


// ---------------------------------------------------------------------
// Simple wrapper around each connected client socket
// ---------------------------------------------------------------------

class Connection {
private:
   // Client socket handle
   int mSocket;

   // Temporary buffer used to handle incoming data
   uchar mTempBuffer[SOCKET_READ_BUFFER_SIZE];
   
   // Stored-up data, waiting for a \r character 
   string mPendingData;
   
public:
   Connection(int ClientSocket);
   ~Connection();
   string GetID() {return IntegerToString(mSocket);}
   
   bool ReadAnyPendingData();
   void ProcessIncomingMessage(string strMessage);
};

// Constructor, called with the handle of a newly accepted socket
Connection::Connection(int ClientSocket)
{
   mPendingData = "";
   mSocket = ClientSocket; 
   
   // Put the client socket into non-blocking mode
   uint nbmode = 1;
   if (ioctlsocket(mSocket, 0x8004667E /* FIONBIO */, nbmode) != 0) {Print("ERROR in setting non-blocking mode on client socket");}
}

// Destructor. Simply close the client socket
Connection::~Connection()
{
   closesocket(mSocket);
}

// Called repeatedly on a timer, to check whether any
// data is available on this client connection. Returns true if the 
// client still seems to be connected (*not* if there's new data); 
// returns false if the connection seems to be dead. 
bool Connection::ReadAnyPendingData()
{
   // Check the client socket for data-readability
   timeval waitfor;
   waitfor.secs = 0;
   waitfor.usecs = 0;

   fd_set PollClientSocket;
   PollClientSocket.count = 1;
   PollClientSocket.single_socket = mSocket;

   int selres = select(0, PollClientSocket, 0, 0, waitfor);
   if (selres > 0) {
      
      // Winsock says that there is data waiting to be read on this socket
      int res = recv(mSocket, mTempBuffer, SOCKET_READ_BUFFER_SIZE, 0);
      if (res > 0) {
         // Convert the buffer to a string, and add it to any pending
         // data which we already have on this connection
         string strIncoming = CharArrayToString(mTempBuffer, 0, res);
         mPendingData += strIncoming;
         
         // Do we have a complete message (or more than one) ending in \r?
         int idxTerm = StringFind(mPendingData, "\r");
         while (idxTerm >= 0) {
            if (idxTerm > 0) {
               string strMsg = StringSubstr(mPendingData, 0, idxTerm);         
               
               // Strip out any \n characters lingering from \r\n combos
               StringReplace(strMsg, "\n", "");
               
               // Print the \r-terminated message in the log
               ProcessIncomingMessage(strMsg);
            }               
         
            // Keep looping until we have extracted all the \r delimited 
            // messages, and leave any residue in the pending data 
            mPendingData = StringSubstr(mPendingData, idxTerm + 1);
            idxTerm = StringFind(mPendingData, "\r");
         }
         
         return true;
      
      } else if (WSAGetLastError() == 10035 /* WSAEWOULDBLOCK */) {
         // Would block; not an error
         return true;
         
      } else {
         // recv() failed. Assume socket is dead
         return false;
      }
   
   } else if (selres == -1) {
      // Assume socket is dead
      return false;
      
   } else {
      // No pending data
      return true;
   }
}

// Can override this with whatever you want to do with incoming messages:
// handling trading commands, send data back down the socket etc etc etc
void Connection::ProcessIncomingMessage(string strMessage)
{
   Print("#" , GetID() , ": " , strMessage);
}