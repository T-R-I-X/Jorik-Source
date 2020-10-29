local ChatService = game:GetService("Chat")
ChatService:RegisterChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, function()
	return {BubbleChatEnabled = true, ClassicChatEnabled = false}
end)