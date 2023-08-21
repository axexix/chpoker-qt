#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QString>
#include <QSettings>
#include <qqml.h>

class Settings : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool insecure READ insecure WRITE setInsecure NOTIFY insecureChanged)
    Q_PROPERTY(QString hostname READ hostname WRITE setHostname NOTIFY hostnameChanged)
    Q_PROPERTY(QString identity READ identity WRITE setIdentity NOTIFY identityChanged)
    Q_PROPERTY(bool logPanelOpen READ logPanelOpen WRITE setLogPanelOpen NOTIFY logPanelOpenChanged)

public:
    explicit Settings(QObject *parent = nullptr);

    bool insecure();
    void setInsecure(const bool &insecure);

    QString hostname();
    void setHostname(const QString &hostname);

    QString identity();
    void setIdentity(const QString &identity);

    bool logPanelOpen();
    void setLogPanelOpen(const bool &logPanelOpen);

signals:
    void insecureChanged();
    void hostnameChanged();
    void identityChanged();
    void logPanelOpenChanged();

private:
    bool m_insecure;
    QString m_hostname;
    QString m_identity;
    bool m_logPanelOpen;
    QSettings m_settings;

    void checkSettingsReady();
    void loadSettings();

};

#endif // SETTINGS_H
