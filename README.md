# Multi-Client Chatting Application

A real-time multi-client chat system featuring a Python WebSocket server, a Python CLI client, and a cross-platform Flutter chat application.

---

## 📁 Repository Structure

```
Multi-Client/
├── server.py                        # Asynchronous Python WebSocket server
├── client.py                        # Terminal/CLI Python chat client
├── requirements.txt                 # Python dependencies
└── flutter_app_for_multi_client/    # Flutter mobile / desktop / web chat client
    └── multi_client/
```

---

## 🚀 Features

- **Real-Time Messaging**: Built on WebSockets for instant message delivery and low latency.
- **Python WebSocket Server**: Asynchronous broadcasting using `websockets` and `asyncio`.
- **CLI Chat Client**: Lightweight terminal chat client with multi-threaded message handling.
- **Flutter Client**: Cross-platform Flutter UI for desktop, mobile, and web.

---

## 🛠️ Getting Started

### 1. Python Server
```bash
pip install -r requirements.txt
python server.py
```
By default, the server runs on port `9999` (or the port specified by the `PORT` environment variable).

### 2. Python CLI Client
```bash
python client.py
```

### 3. Flutter Client
```bash
cd flutter_app_for_multi_client/multi_client
flutter pub get
flutter run
```
