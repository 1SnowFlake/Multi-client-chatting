import sys
import os

# Fix Windows console encoding for emoji/unicode
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    os.environ["PYTHONIOENCODING"] = "utf-8"

import websocket
import threading

print("=" * 30)
print("   Chat Client")
print("=" * 30)
nickname = input("Choose a nickname: ")

def on_message(ws, message):
    print(f"\n>> {message}")
    print("You: ", end="", flush=True)

def on_open(ws):
    ws.send(nickname)
    print(f"[+] Connected as '{nickname}'!")
    print("Type a message and press Enter")
    print("Type 'quit' to exit")
    print("=" * 30)
    def send_loop():
        while True:
            try:
                msg = input("You: ")
                if msg.lower() == "quit":
                    ws.close()
                    break
                if msg.strip():
                    ws.send(msg)
            except:
                break
    threading.Thread(target=send_loop, daemon=True).start()

def on_error(ws, error):
    print(f"[ERROR] {error}")

def on_close(ws, *args):
    print("\n[!] Disconnected from server.")

ws = websocket.WebSocketApp(
    "wss://multi-client-51uu.onrender.com/",
    on_open=on_open,
    on_message=on_message,
    on_error=on_error,
    on_close=on_close
)
ws.run_forever()