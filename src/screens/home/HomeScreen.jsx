import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  FlatList,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Icon from 'react-native-vector-icons/Ionicons';
import Card from '../../components/Card';
import Button from '../../components/Button';
import RequestCard from '../../components/RequestCard';
import { useAuth } from '../../context/AuthContext';
import { useRequests } from '../../context/RequestContext';
import { useNotifications } from '../../context/NotificationContext';
import { getMachines } from '../../services/machineService';
import colors from '../../constants/colors';

const HomeScreen = ({ navigation }) => {
  const { user } = useAuth();
  const { activeRequests, fetchRequests } = useRequests();
  const { unreadCount } = useNotifications();
  const [machineCount, setMachineCount] = useState(0);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const machines = await getMachines();
      setMachineCount(machines.length);
    } catch (error) {
      console.error('Error loading data:', error);
    }
  };

  const handleRequestAction = (request) => {
    if (request.status === 'quote_submitted') {
      navigation.navigate('ViewQuotes', { requestId: request._id || request.id });
    } else if (request.status === 'pending_confirmation') {
      navigation.navigate('RequestDetails', { requestId: request._id || request.id });
    } else {
      navigation.navigate('RequestDetails', { requestId: request._id || request.id });
    }
  };

  const recentRequests = activeRequests.slice(0, 3);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Hello, {user?.firstName} 👋</Text>
            <Text style={styles.subGreeting}>How can we help you today?</Text>
          </View>
          <TouchableOpacity
            onPress={() => navigation.navigate('Notifications')}
            style={styles.notificationButton}
          >
            <Icon name="notifications-outline" size={28} color={colors.textPrimary} />
            {unreadCount > 0 && (
              <View style={styles.badge}>
                <Text style={styles.badgeText}>{unreadCount}</Text>
              </View>
            )}
          </TouchableOpacity>
        </View>

        <View style={styles.statsContainer}>
          <Card style={styles.statCard}>
            <Text style={styles.statValue}>{activeRequests.length}</Text>
            <Text style={styles.statLabel}>Active Requests</Text>
          </Card>
          <Card style={styles.statCard}>
            <Text style={styles.statValue}>{machineCount}</Text>
            <Text style={styles.statLabel}>Machines</Text>
          </Card>
        </View>

        <Button
          title="+ Create New Request"
          onPress={() => navigation.navigate('CreateRequest')}
          style={styles.createButton}
        />

        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>Active Requests</Text>
            {activeRequests.length > 3 && (
              <TouchableOpacity onPress={() => navigation.navigate('Requests')}>
                <Text style={styles.seeAll}>See All</Text>
              </TouchableOpacity>
            )}
          </View>

          {recentRequests.length > 0 ? (
            <FlatList
              data={recentRequests}
              keyExtractor={(item) => item._id || item.id}
              renderItem={({ item }) => (
                <RequestCard
                  request={item}
                  onPress={() =>
                    navigation.navigate('RequestDetails', {
                      requestId: item._id || item.id,
                    })
                  }
                  onActionPress={handleRequestAction}
                />
              )}
              scrollEnabled={false}
            />
          ) : (
            <Card style={styles.emptyCard}>
              <Text style={styles.emptyText}>No active requests</Text>
              <Text style={styles.emptySubtext}>
                Create a request to get started
              </Text>
            </Card>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  scrollView: {
    flex: 1,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('4%'),
  },
  greeting: {
    fontSize: RFValue(24),
    fontWeight: '700',
    color: colors.textPrimary,
  },
  subGreeting: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
    marginTop: wp('1%'),
  },
  notificationButton: {
    position: 'relative',
  },
  badge: {
    position: 'absolute',
    top: -4,
    right: -4,
    backgroundColor: colors.error,
    borderRadius: 10,
    minWidth: 20,
    height: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  badgeText: {
    color: '#ffffff',
    fontSize: RFValue(10),
    fontWeight: '700',
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: wp('4%'),
    gap: wp('4%'),
    marginBottom: wp('4%'),
  },
  statCard: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: wp('6%'),
  },
  statValue: {
    fontSize: RFValue(28),
    fontWeight: '700',
    color: colors.primary,
    marginBottom: wp('1%'),
  },
  statLabel: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
  },
  createButton: {
    marginHorizontal: wp('4%'),
    marginBottom: wp('6%'),
  },
  section: {
    paddingHorizontal: wp('4%'),
    marginBottom: wp('6%'),
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: wp('4%'),
  },
  sectionTitle: {
    fontSize: RFValue(18),
    fontWeight: '700',
    color: colors.textPrimary,
  },
  seeAll: {
    fontSize: RFValue(14),
    color: colors.primary,
    fontWeight: '600',
  },
  emptyCard: {
    alignItems: 'center',
    paddingVertical: wp('8%'),
  },
  emptyText: {
    fontSize: RFValue(16),
    fontWeight: '600',
    color: colors.textPrimary,
    marginBottom: wp('1%'),
  },
  emptySubtext: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
  },
});

export default HomeScreen;
