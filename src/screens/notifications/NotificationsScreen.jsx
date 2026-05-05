import React, { useEffect } from 'react';
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
import Icon from 'react-native-vector-icons/Ionicons';
import Card from '../../components/Card';
import Header from '../../components/Header';
import EmptyState from '../../components/EmptyState';
import { useNotifications } from '../../context/NotificationContext';
import colors from '../../constants/colors';
import { getTimeAgo } from '../../utils/formatters';

const NotificationsScreen = ({ navigation }) => {
  const { notifications, fetchNotifications, markAllRead } = useNotifications();

  useEffect(() => {
    fetchNotifications();
  }, []);

  const getNotificationIcon = (type) => {
    switch (type) {
      case 'quote_received':
        return 'document-text';
      case 'status_update':
        return 'sync';
      case 'payment':
        return 'card';
      case 'message':
        return 'chatbubble';
      default:
        return 'notifications';
    }
  };

  const handleNotificationPress = (notification) => {
    // Navigate based on notification type
    if (notification.requestId) {
      navigation.navigate('RequestDetails', { requestId: notification.requestId });
    }
  };

  const renderNotification = ({ item }) => (
    <TouchableOpacity
      onPress={() => handleNotificationPress(item)}
      activeOpacity={0.9}
    >
      <Card style={[styles.notificationCard, !item.read && styles.unreadCard]}>
        <View style={styles.iconContainer}>
          <Icon
            name={getNotificationIcon(item.type)}
            size={24}
            color={colors.primary}
          />
        </View>
        <View style={styles.notificationContent}>
          <Text style={styles.notificationTitle}>{item.title}</Text>
          <Text style={styles.notificationMessage}>{item.message}</Text>
          <Text style={styles.notificationTime}>
            {getTimeAgo(item.createdAt || item.created_at)}
          </Text>
        </View>
        {!item.read && <View style={styles.unreadDot} />}
      </Card>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <Header
        title="Notifications"
        onBack={() => navigation.goBack()}
        rightComponent={
          notifications.length > 0 && (
            <TouchableOpacity onPress={markAllRead}>
              <Text style={styles.markAllRead}>Mark all read</Text>
            </TouchableOpacity>
          )
        }
      />

      {notifications.length === 0 ? (
        <EmptyState
          icon="notifications-outline"
          title="No Notifications"
          message="You're all caught up! We'll notify you of any updates."
        />
      ) : (
        <FlatList
          data={notifications}
          keyExtractor={(item) => item._id || item.id}
          renderItem={renderNotification}
          contentContainerStyle={styles.list}
          onRefresh={fetchNotifications}
          refreshing={false}
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
  markAllRead: {
    fontSize: RFValue(13),
    color: colors.primary,
    fontWeight: '600',
  },
  list: {
    padding: wp('4%'),
  },
  notificationCard: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: wp('3%'),
    position: 'relative',
  },
  unreadCard: {
    backgroundColor: `${colors.primary}05`,
    borderLeftWidth: 3,
    borderLeftColor: colors.primary,
  },
  iconContainer: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: `${colors.primary}20`,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: wp('3%'),
  },
  notificationContent: {
    flex: 1,
  },
  notificationTitle: {
    fontSize: RFValue(15),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('1%'),
  },
  notificationMessage: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
    lineHeight: RFValue(18),
    marginBottom: wp('1%'),
  },
  notificationTime: {
    fontSize: RFValue(11),
    color: colors.textSecondary,
  },
  unreadDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: colors.primary,
    position: 'absolute',
    top: wp('2%'),
    right: wp('2%'),
  },
});

export default NotificationsScreen;
