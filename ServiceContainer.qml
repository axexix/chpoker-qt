import QtQml 2.12
import QtQuick 2.12

Item {
    id: root

    property var registeredServices: []

    Component.onCompleted: {
        for (var i in root.data) {
            var service = root.data[i]
            console.log("registering service: " + service.serviceName)

            registeredServices.push(service)

            var registrationHandlerName = "register" + service.serviceName

            if (root[registrationHandlerName])
                root[registrationHandlerName](service)
        }
    }

    function callMethodByServiceName(serviceName, methodName)
    {
        var args = [].slice.call(arguments, 2)

        registeredServices.forEach(function(service)
        {
            if (service.serviceName === serviceName)
            {
                service[methodName].apply(service, args)
            }
        })
    }

    function applyMethodByServiceName(serviceName, methodName, args)
    {
        registeredServices.forEach(function(service)
        {
            if (service.serviceName === serviceName)
            {
                try
                {
                    service[methodName].apply(service, args)
                }
                catch (TypeError) {
                    console.log("service " + serviceName + " does not provide a method " + methodName)
                }
            }
        })
    }

}
