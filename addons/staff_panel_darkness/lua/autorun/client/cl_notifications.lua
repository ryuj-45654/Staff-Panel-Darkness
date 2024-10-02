-- cl_notifications.lua

-- Función para crear una notificación en pantalla
local function createNotification(message, notifyType, duration)
    notification.AddLegacy(message, notifyType, duration)
    surface.PlaySound("buttons/button15.wav")
end

-- Ejemplo de cómo usar la función de notificación en el cliente
-- notifyType: 0 = Error, 1 = Genérico, 2 = Advertencia
net.Receive("SendNotification", function()
    local message = net.ReadString()
    local notifyType = net.ReadUInt(3)
    local duration = net.ReadUInt(8)

    createNotification(message, notifyType, duration)
end)

-- Ejemplo para probar la notificación desde la consola del cliente
concommand.Add("test_notification", function()
    createNotification("This is a test notification", 1, 5)
end)