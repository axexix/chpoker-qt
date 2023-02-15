import QtQuick 2.14
import QtQuick.Controls 2.15


Column {
    id: root
    signal login()
    signal hostMeeting()

    property string hostname: ""
    property string username: ""
    property bool canHost: false
    property bool identityValid: false

    spacing: 20

    onVisibleChanged: {
        if (visible) {
            loginField.focus = true
        }
    }

    Text {
        id: txt
        text: "chpoker"
        font.pointSize: 24
        font.bold: true
    }

    Column {
        spacing: 10
        anchors.left: parent.left
        anchors.right: parent.right

        TextField {
            id: hostnameField

            anchors.left: parent.left
            anchors.right: parent.right

            placeholderText: "hostname"
            text: hostname
        }

        Label {
            text: "Logged in as " + root.username
            visible: root.identityValid
        }

        Label {
            text: "Please login with your identity provider"
            visible: !root.identityValid
        }

        Button {
            text: "join as a voter"

            anchors.left: parent.left
            anchors.right: parent.right
            visible: root.identityValid

            onClicked: root.login()
        }
    }

    Text {
        text: "or"
        visible: root.canHost

        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        text: "host a meeting"
        visible: root.canHost

        anchors.left: parent.left
        anchors.right: parent.right

        onClicked: {
            root.hostMeeting()
        }
    }
}
