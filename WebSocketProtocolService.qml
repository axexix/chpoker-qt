import QtQml 2.12
import QtQuick 2.12
import QtWebSockets 1.1

Item {
    id: root

    signal messageReceived(string service, string name, var arguments)

    property Item container
    property string serviceName: "WebSocketProtocolService"

    property string url
    property string clientId
    property string identity
    property bool connected: false

    property var delayedMessages: []

    onConnectedChanged: {
        if (connected)
            sendDelayedMessages()
    }

    function callMethod(service, method, params)
    {
        var message = {
            type: "rpc",
            rpc: {
                service: service,
                method: method
            }
        }

        if (params)
            message.rpc.params = params

        if (connected)
            ws.sendTextMessage(JSON.stringify(message))
        else
            delayedMessages.splice(0, Infinity, JSON.stringify(message))
    }

    function sendHandshake()
    {
        var message = {
            type: "hello"
        }

        if (clientId !== "")
            message.client_id = clientId

        if (identity !== "")
            message.identity = root.identity

        ws.sendTextMessage(JSON.stringify(message))
    }

    function sendDelayedMessages()
    {
        while (delayedMessages.length > 0)
            ws.sendTextMessage(delayedMessages.shift())
    }

    function setConnected(value)
    {
        ws.active = value
    }

    Timer {
        id: reconnectTimer

        running: false
        repeat: true
        interval: 5000

        onTriggered: {
            console.log("reconnecting to " + root.url + " ...")
            ws.active = false
            ws.active = true
        }
    }

    WebSocket {
        id: ws
        url: root.url
        active: true

        onStatusChanged: {
            if (status == WebSocket.Open)
            {
                reconnectTimer.stop()
                root.sendHandshake()
            }
            else if (status == WebSocket.Closed)
            {
                reconnectTimer.start()
                root.connected = false
            }

        }

        onTextMessageReceived: {
            var response = JSON.parse(message)

            if (response.type === "hello")
            {
                clientId = response.client_id
                console.log("hello: " + clientId)
                root.connected = true
                return
            }
            else if (response.type === "event")
            {
                var event = response.event
                var handlerName = event.name
                    .split("_")
                    .map(function(v, i)
                    {
                        return i === 0 ? v : v[0].toUpperCase() + v.slice(1)
                    })
                    .join("")

                container.applyMethodByServiceName(event.service, handlerName, event.arguments)
            }
            else
            {
                console.log("unhandled protocol message type: " + response.type)
            }
        }
    }

}
