#include <QProcessEnvironment>
#include <QTimer>
#include "settings.h"

Settings::Settings(QObject *parent)
    : QObject{parent}
{
    checkSettingsReady();
}

bool Settings::insecure()
{
    return m_insecure;
}

void Settings::setInsecure(const bool &insecure)
{
    if (m_insecure == insecure)
        return;

    qDebug() << "insecure changed:" << insecure;

    m_insecure = insecure;
    m_settings.setValue("insecure", insecure);

    emit insecureChanged();
}

QString Settings::hostname()
{
    return m_hostname;
}

void Settings::setHostname(const QString &hostname)
{
    if (m_hostname == hostname)
        return;

    qDebug() << "hostname changed:" << hostname;

    m_hostname = hostname;
    m_settings.setValue("hostname", hostname);

    emit hostnameChanged();
}

QString Settings::identity()
{
    return m_identity;
}

void Settings::setIdentity(const QString &identity)
{
    if (m_identity == identity)
        return;

    qDebug() << "identity changed:" << identity;

    m_identity = identity;
    m_settings.setValue("identity", identity);

    emit identityChanged();
}

void Settings::checkSettingsReady()
{
    if (m_settings.status() == QSettings::NoError) {
        loadSettings();
    } else {
        qDebug() << "settings not ready, waiting 10s...";
        QTimer::singleShot(10, this, &Settings::checkSettingsReady);
    }
}

void Settings::loadSettings()
{
    qDebug() << "loading settings...";
    qDebug() << "system environment: " << QProcessEnvironment::systemEnvironment().toStringList();

    QString defaultHostname = QProcessEnvironment::systemEnvironment().value("REMOTE_HOST", "localhost");
    bool defaultInsecure = QProcessEnvironment::systemEnvironment().value("INSECURE", "") == "1";

    setHostname(m_settings.value("hostname", defaultHostname).toString());
    setInsecure(m_settings.value("insecure", defaultInsecure).toBool());

    qDebug() << "hostname:" << hostname();
    qDebug() << "insecure:" << insecure();
}
