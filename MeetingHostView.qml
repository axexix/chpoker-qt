import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    signal newTarget()
    signal revealScores()

    property bool scoresVisible: false

    function enable()
    {
        visible = true
        userModel.clear()
    }

    function joinedMeeting(user)
    {
        if (userModel.findById(user.id) !== null) {
            updateUser(user)
            return
        }

        userModel.append({
            id:        user.id,
            name:      user.name,
            active:    user.active,
            score:     user.score
        })
    }

    function leftMeeting(user)
    {
        userModel.remove(userModel.findById(user.id))
    }

    function updateUser(user)
    {
        var idx = userModel.findById(user.id)

        for (var k in user)
            userModel.setProperty(idx, k, user[k])
    }

    function resetScores()
    {
        scoresVisible = false
        for (var i = 0; i < userModel.count; i++)
            userModel.setProperty(i, "score", 0)
    }

    Action {
        id: revealAction
        text: qsTr("&Reveal")
        onTriggered: root.revealScores()
    }

    Action {
        id: newTargetAction
        text: qsTr("&New target")
        onTriggered: root.newTarget()
    }

    ListModel {
        id: userModel

        property string id
        property bool active: false
        property string name
        property int score: 0

        function findById(id)
        {
            for (var i = 0; i < count; i++)
            {
                if (get(i).id === id)
                    return i
            }

            return null
        }
    }

    ColumnLayout {
        anchors.fill: parent

        spacing: 0

        ToolBar {
            id: header

            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                Label {
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true

                    text: "Hosting a session"
                }

                ToolButton {
                    action: revealAction
                }

                ToolButton {
                    action: newTargetAction
                }
            }
        }

        GridLayout {
            id: flow

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10

            columns: Math.ceil(Math.sqrt(userModel.count / (height / width)))
            rowSpacing: 10
            columnSpacing: 10

            Repeater {
                model: userModel

                Rectangle {
                    color: active ? "lightgreen" : "lightgrey"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Text {
                        text: " " + name
                        font.pointSize: Math.min(parent.width, parent.height) / 10
                    }

                    Text {
                        text: score === 0 ? "…" : (root.scoresVisible ? (score === -1 ? "∞" : score) : "✓")
                        font.pointSize: Math.min(parent.width, parent.height) / 3
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }

}
