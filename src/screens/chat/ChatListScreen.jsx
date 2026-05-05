import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  FlatList,
  TouchableOpacity,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Card from '../../components/Card';
import EmptyState from '../../components/EmptyState';
import LoadingSpinner from '../../components/LoadingSpinner';
import { getChats } from '../../services/chatService';
import colors from '../../constants/colors';
import { truncateText, getTimeAgo } from '../../utils/formatters';

const ChatListScreen = ({ navigation }) => {
  const [chats, setChats] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    loadChats();
  }, []);

  const loadChats = async () => {
    try {
      setLoading(true);
      const data = await getChats();
      setChats(data);
    } catch (error) {
      console.error('Failed to load chats:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const renderChat = ({ item }) => {
    const expert = item.expert || item.producer || item.participants?.find(p => p.role === 'producer');
    const lastMessage = item.lastMessage || item.last_message;
    const unreadCount = item.unreadCount || item.unread_count || 0;

    return (
      <TouchableOpacity
        onPress={() => navigation.navigate('Chat', { chatId: item._id || item.id })}
        activeOpacity={0.9}
      >
        <Card style={styles.chatCard}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>
              {expert?.firstName?.[0] || 'E'}
            </Text>
          </View>
          <View style={styles.chatInfo}>
            <View style={styles.chatHeader}>
              <Text style={styles.expertName}>
                {expert?.firstName} {expert?.lastName}
              </Text>
              <Text style={styles.time}>
                {getTimeAgo(lastMessage?.createdAt || lastMessage?.created_at)}
              </Text>
            </View>
            <Text style={styles.machineName}>
              {item.request?.machine?.name || 'Service Request'}
            </Text>
            <Text style={styles.lastMessage}>
              {truncateText(lastMessage?.content || 'No messages yet', 50)}
            </Text>
          </View>
          {unreadCount > 0 && (
            <View style={styles.unreadBadge}>
              <Text style={styles.unreadText}>{unreadCount}</Text>
            </View>
          )}
        </Card>
      </TouchableOpacity>
    );
  };

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Messages</Text>
      </View>

      {chats.length === 0 ? (
        <EmptyState
          icon="chatbubbles-outline"
          title="No Conversations"
          message="Start a conversation with an expert from your requests"
        />
      ) : (
        <FlatList
          data={chats}
          keyExtractor={(item) => item._id || item.id}
          renderItem={renderChat}
          contentContainerStyle={styles.list}
          refreshing={refreshing}
          onRefresh={() => {
            setRefreshing(true);
            loadChats();
          }}
        />
      )}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('4%'),
    backgroundColor: colors.card,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  title: {
    fontSize: RFValue(20),
    fontWeight: '700',
    color: colors.textPrimary,
  },
  list: {
    padding: wp('4%'),
  },
  chatCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: wp('3%'),
    position: 'relative',
  },
  avatar: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: wp('3%'),
  },
  avatarText: {
    fontSize: RFValue(18),
    fontWeight: 'bold',
    color: '#ffffff',
  },
  chatInfo: {
    flex: 1,
  },
  chatHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: wp('1%'),
  },
  expertName: {
    fontSize: RFValue(15),
    fontWeight: '700',
    color: colors.textPrimary,
  },
  time: {
    fontSize: RFValue(11),
    color: colors.textSecondary,
  },
  machineName: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    marginBottom: wp('1%'),
  },
  lastMessage: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
  },
  unreadBadge: {
    position: 'absolute',
    top: wp('2%'),
    right: wp('2%'),
    backgroundColor: colors.primary,
    borderRadius: 10,
    minWidth: 20,
    height: 20,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: wp('1.5%'),
  },
  unreadText: {
    color: '#ffffff',
    fontSize: RFValue(10),
    fontWeight: '700',
  },
});

export default ChatListScreen;
