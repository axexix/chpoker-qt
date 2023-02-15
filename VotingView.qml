import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property string userName: "noname"
    property int score: 0
    property bool votingEnabled: true
    property bool moderator: false
    property bool debug: false
    property var allowedValues: [1, 2, 3, 5, 8, 13, 21]

    signal logout()
    signal toggleOnline()
    signal newTarget()

    function enable()
    {
        visible = true
        focus = true
        resetScore()
    }

    function resetScore()
    {
        score = 0
    }

    Keys.onPressed: {
        var value = parseInt(event.text)
        if (!isNaN(value) && root.allowedValues.indexOf(value) > -1 && root.votingEnabled)
            root.score = value
    }

    ListModel {
        id: scoreModel

        Component.onCompleted: {
            for (var i in root.allowedValues)
            {
                var value = root.allowedValues[i]
                insert(i, {value: value, score: value.toString()})
            }
        }

        ListElement {
            value: -1
            score:  "∞"
        }
    }

    ToolBar {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Label {
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true

                text: "Welcome, " + root.userName
            }

            ToolButton {
                text: "Online/Offline"
                visible: root.debug

                onClicked: {
                    root.toggleOnline()
                }
            }

            ToolButton {
                text: "New target"
                visible: root.moderator

                onClicked: {
                    root.newTarget()
                }
            }

            ToolButton {
                id: logoutButton

                text: "Log out"

                onClicked: {
                    root.logout()
                }
            }
        }
    }

    ScrollView {
        id: content

        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        contentWidth: availableWidth

        Flow {
            anchors.fill: parent
            spacing: 10
            anchors.margins: 10

            Repeater {
                model: scoreModel

                Rectangle {
                    id: scoreButton

                    width: (Math.min(content.width, content.height) - 10) / 3 - 10
                    height: width
                    color: root.score === value ? "lightblue" : (root.votingEnabled ? "lightgreen" : "lightgrey")

                    Text {
                        text: score
                        font.pointSize: scoreButton.width / 3
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        x: 0; y: 0
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (root.votingEnabled && value)
                                root.score = value
                        }
                    }
                }
            }
        }
    }
}
