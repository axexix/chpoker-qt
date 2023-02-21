import QtQuick 2.12

Item {
    id: pokerService

    property Item remoteProtocol
    property string serviceName: "PokerService"

    signal loggedInVoter(bool votingEnabled)
    signal loggedInHost()
    signal loggedOutUser()
    signal joinedMeeting(var user)
    signal leftMeeting(var user)
    signal updatedUser(var user)
    signal profileUpdated(var user)
    signal newTarget()
    signal scoresRevealed()
    signal noIdentityFound()
    signal logMessageSent(string message)

    function loginVoter()
    {
        remoteProtocol.callMethod("PokerService", "login_voter")
    }

    function loginHost()
    {
        remoteProtocol.callMethod("PokerService", "login_host")
    }

    function logoutUser()
    {
        remoteProtocol.callMethod("PokerService", "logout_user")
    }

    function scoreTarget(score)
    {
        remoteProtocol.callMethod("PokerService", "estimate_target", {score: score})
    }

    function createTarget()
    {
        remoteProtocol.callMethod("PokerService", "new_target")
    }

    function revealScores()
    {
        remoteProtocol.callMethod("PokerService", "reveal_scores")
    }
}
