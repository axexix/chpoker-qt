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

            placeholderText: qsTr("hostname")
            text: hostname
        }

        Label {
            text: "Logged in as " + root.username
            visible: root.identityValid
        }

        Label {
            text: qsTr("Please login with your identity provider")
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
        text: qsTr("or")
        visible: root.canHost

        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        text: qsTr("host a meeting")
        visible: root.canHost

        anchors.left: parent.left
        anchors.right: parent.right

        onClicked: {
            root.hostMeeting()
        }
    }

    Text {
        anchors.right: parent.right

        text: "<a href='https://github.com/axexix/chpoker-qt'>about & source</a>"
        onLinkActivated: Qt.openUrlExternally(link)

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        }
    }
}
