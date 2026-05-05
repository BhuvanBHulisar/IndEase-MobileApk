import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  FlatList,
  TextInput,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Icon from 'react-native-vector-icons/Ionicons';
import ChatBubble from '../../components/ChatBubble';
import Header from '../../components/Header';
import LoadingSpinner from '../../components/LoadingSpinner';
import { getMessages, sendMessage as sendMessageAPI } from '../../services/chatService';
import { subscribeToMessages, sendMessage as sendMessageSocket } from '../../socket/socketService';
import { useAuth } from '../../context/AuthContext';
import colors from '../../constants/colors';

const ChatScreen = ({ navigation, route }) => {
  const { chatId, requestId } = route.params;
  const { user } = useAuth();
  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const flatListRef = useRef(null);

  useEffect(() => {
    loadMessages();
    setupSocketListener();
  }, [chatId]);

  const setupSocketListener = () => {
    subscribeToMessages((data) => {
      if (data.chatId === chatId) {
        setMessages((prev) => [...prev, data.message]);
        setTimeout(() => scrollToBottom(), 100);
      }
    });
  };

  const loadMessages = async () => {
    try {
      setLoading(true);
      const data = await getMessages(chatId);
      setMessages(data);
      setTimeout(() => scrollToBottom(), 100);
    } catch (error) {
      console.error('Failed to load messages:', error);
    } finally {
      setLoading(false);
    }
  };

  const scrollToBottom = () => {
    if (flatListRef.current && messages.length > 0) {
      flatListRef.current.scrollToEnd({ animated: true });
    }
  };

  const handleSend = async () => {
    if (!inputText.trim() || sending) return;

    const messageText = inputText.trim();
    setInputText('');
    setSending(true);

    try {
      // Optimistically add message
      const tempMessage = {
        _id: Date.now().toString(),
        content: messageText,
        sender: user._id || user.id,
        createdAt: new Date().toISOString(),
      };
      setMessages((prev) => [...prev, tempMessage]);
      scrollToBottom();

      // Send via API
      await sendMessageAPI(chatId, messageText);

      // Also emit via socket for real-time
      sendMessageSocket(chatId, messageText);
    } catch (error) {
      console.error('Failed to send message:', error);
      // Remove optimistic message on error
      setMessages((prev) => prev.filter((m) => m._id !== tempMessage._id));
    } finally {
      setSending(false);
    }
  };

  const renderMessage = ({ item }) => {
    const isOwn = (item.sender?._id || item.sender) === (user._id || user.id);
    return <ChatBubble message={item} isOwn={isOwn} />;
  };

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <Header
        title="Chat with Expert"
        onBack={() => navigation.goBack()}
      />

      <KeyboardAvoidingView
        style={styles.keyboardView}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 0}
      >
        <FlatList
          ref={flatListRef}
          data={messages}
          keyExtractor={(item) => item._id || item.id}
          renderItem={renderMessage}
          contentContainerStyle={styles.messageList}
          onContentSizeChange={scrollToBottom}
        />

        <View style={styles.inputContainer}>
          <TextInput
            style={styles.input}
            value={inputText}
            onChangeText={setInputText}
            placeholder="Type a message..."
            placeholderTextColor={colors.textSecondary}
            multiline
            maxLength={500}
          />
          <TouchableOpacity
            onPress={handleSend}
            style={[
              styles.sendButton,
              (!inputText.trim() || sending) && styles.sendButtonDisabled,
            ]}
            disabled={!inputText.trim() || sending}
          >
            <Icon
              name="send"
              size={20}
              color={inputText.trim() && !sending ? '#ffffff' : colors.textSecondary}
            />
          </TouchableOpacity>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  keyboardView: {
    flex: 1,
  },
  messageList: {
    paddingVertical: wp('4%'),
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('3%'),
    backgroundColor: colors.card,
    borderTopWidth: 1,
    borderTopColor: colors.border,
  },
  input: {
    flex: 1,
    maxHeight: 100,
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('2.5%'),
    backgroundColor: colors.background,
    borderRadius: 20,
    fontSize: RFValue(14),
    color: colors.textPrimary,
    marginRight: wp('2%'),
  },
  sendButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  sendButtonDisabled: {
    backgroundColor: colors.border,
  },
});

export default ChatScreen;
