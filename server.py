import asyncio
import os
import websockets

clients = {}

async def broadcast(message, sender=None):
    for client in list(clients):
        if client != sender:
            try:
                await client.send(message)
            except:
                pass

async def handle(websocket):
    nickname = None
    try:
        nickname = await websocket.recv()
        clients[websocket] = nickname
        print(f"[+] {nickname} connected! Total: {len(clients)}")
        await broadcast(f"[JOIN] {nickname} joined!", sender=websocket)
        async for message in websocket:
            print(f"{nickname}: {message}")
            await broadcast(f"{nickname}: {message}", sender=websocket)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if websocket in clients:
            del clients[websocket]
        if nickname:
            await broadcast(f"[LEFT] {nickname} left.")
            print(f"[-] {nickname} disconnected!")

async def main():
    port = int(os.environ.get("PORT", 9999))
    print(f"Server starting on port {port}...")
    async with websockets.serve(handle, "0.0.0.0", port) as server:
        print(f"[+] Server ready on port {port}!")
        await asyncio.get_event_loop().create_future()

asyncio.run(main())