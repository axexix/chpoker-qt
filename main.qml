import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.15

import iers.chpoker 1.0

Window {
    visible: true
    width: 480
    height: 640
    title: "chpoker"

    Component.onCompleted: {
        console.log(settings.hostname)
    }

    Settings {
        id: settings
    }

    ServiceContainer {
        id: serviceContainer

        WebSocketProtocolService {
            id: remoteProtocolService
            url: "%1://%2/ws".arg(settings.insecure ? "ws": "wss").arg(settings.hostname)
            container: serviceContainer
            identity: settings.identity
        }

        PokerService {
            id: pokerService
            remoteProtocol: remoteProtocolService

            onNoIdentityFound: {
                loginForm.identityValid = false
            }
            onLoggedInVoter: {
                loginForm.visible = false
                teamMemberForm.userName = loginForm.username
                teamMemberForm.votingEnabled = votingEnabled
                teamMemberForm.enable()
            }
            onLoggedInHost: {
                loginForm.visible = false
                meetingHostView.enable()
            }
            onLoggedOutUser: {
                teamMemberForm.visible = false
                meetingHostView.visible = false
                loginForm.visible = true
            }
            onJoinedMeeting: {
                meetingHostView.joinedMeeting(user)
            }
            onLeftMeeting: {
                meetingHostView.leftMeeting(user)
            }
            onUpdatedUser: {
                meetingHostView.updateUser(user)
            }
            onProfileUpdated: {
                loginForm.identityValid = true
                loginForm.canHost = user.can_host
                loginForm.username = user.name

                if (teamMemberForm.visible) {
                    teamMemberForm.score = user.score
                }
            }
            onNewTarget: {
                if (meetingHostView.visible) {
                    meetingHostView.resetScores()
                }

                if (teamMemberForm.visible) {
                    teamMemberForm.resetScore()
                    teamMemberForm.votingEnabled = true
                }
            }
            onScoresRevealed: {
                meetingHostView.scoresVisible = true
                teamMemberForm.votingEnabled = false
            }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        anchors.bottomMargin: 10
        anchors.rightMargin: 10

        text: remoteProtocolService.connected ? "online" : "offline"
    }

    LoginForm {
        id: loginForm

        anchors.centerIn: parent
        height: 300
        width: 300

        hostname: settings.hostname
        onHostnameChanged: settings.hostname = hostname

        onLogin: {
            pokerService.loginVoter()
        }

        onHostMeeting: {
            pokerService.loginHost()
        }
    }

    VotingView {
        id: teamMemberForm

        anchors.fill: parent

        visible: false

        onLogout: {
            pokerService.logoutUser()
        }

        onScoreChanged: {
            if (score)
                pokerService.scoreTarget(score)
        }

        onNewTarget: {
            pokerService.createTarget()
        }

        onToggleOnline: {
            remoteProtocolService.setConnected(!remoteProtocolService.connected)
        }
    }

    MeetingHostView {
        id: meetingHostView

        anchors.fill: parent

        visible: false

        onNewTarget: {
            pokerService.createTarget()
        }

        onRevealScores: {
            pokerService.revealScores()
        }
    }

    Shortcut {
        sequence: "Ctrl+Meta+#"
        onActivated: {
            debugPanel.open()
        }
    }

    Popup {
        id: debugPanel

        anchors.centerIn: parent

        padding: 10
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        contentItem: ColumnLayout {
            TextArea {
                id: debugIdentity

                Layout.fillWidth: true

                placeholderText: "<debug identity>"
                onEditingFinished: settings.identity = text
            }
        }
    }
}
