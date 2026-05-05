import React, { useState } from 'react';
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
import RequestCard from '../../components/RequestCard';
import EmptyState from '../../components/EmptyState';
import LoadingSpinner from '../../components/LoadingSpinner';
import { useRequests } from '../../context/RequestContext';
import colors from '../../constants/colors';

const FILTERS = ['All', 'Pending', 'Active', 'Completed'];

const RequestsScreen = ({ navigation }) => {
  const { requests, loading, refreshing, refresh } = useRequests();
  const [activeFilter, setActiveFilter] = useState('All');

  const getFilteredRequests = () => {
    switch (activeFilter) {
      case 'Pending':
        return requests.filter((r) =>
          ['broadcast', 'quote_submitted'].includes(r.status)
        );
      case 'Active':
        return requests.filter((r) =>
          ['quote_approved', 'en_route', 'in_progress', 'pending_confirmation'].includes(
            r.status
          )
        );
      case 'Completed':
        return requests.filter((r) =>
          ['completed', 'cancelled'].includes(r.status)
        );
      default:
        return requests;
    }
  };

  const handleRequestAction = (request) => {
    if (request.status === 'quote_submitted') {
      navigation.navigate('ViewQuotes', { requestId: request._id || request.id });
    } else if (request.status === 'pending_confirmation') {
      navigation.navigate('RequestDetails', { requestId: request._id || request.id });
    } else if (['en_route', 'in_progress'].includes(request.status)) {
      // Navigate to chat
      navigation.navigate('Chat', { requestId: request._id || request.id });
    } else {
      navigation.navigate('RequestDetails', { requestId: request._id || request.id });
    }
  };

  const filteredRequests = getFilteredRequests();

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>My Requests</Text>
      </View>

      <View style={styles.filterContainer}>
        {FILTERS.map((filter) => (
          <TouchableOpacity
            key={filter}
            onPress={() => setActiveFilter(filter)}
            style={[
              styles.filterButton,
              activeFilter === filter && styles.filterButtonActive,
            ]}
          >
            <Text
              style={[
                styles.filterText,
                activeFilter === filter && styles.filterTextActive,
              ]}
            >
              {filter}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {filteredRequests.length === 0 ? (
        <EmptyState
          icon="document-text-outline"
          title="No Requests Found"
          message={
            activeFilter === 'All'
              ? 'Create your first service request'
              : `No ${activeFilter.toLowerCase()} requests`
          }
          actionLabel={activeFilter === 'All' ? 'Create Request' : undefined}
          onAction={
            activeFilter === 'All'
              ? () => navigation.navigate('CreateRequest')
              : undefined
          }
        />
      ) : (
        <FlatList
          data={filteredRequests}
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
          contentContainerStyle={styles.list}
          refreshing={refreshing}
          onRefresh={refresh}
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
  filterContainer: {
    flexDirection: 'row',
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('3%'),
    backgroundColor: colors.card,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
    gap: wp('2%'),
  },
  filterButton: {
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('2%'),
    borderRadius: 20,
    backgroundColor: colors.background,
  },
  filterButtonActive: {
    backgroundColor: colors.primary,
  },
  filterText: {
    fontSize: RFValue(13),
    fontWeight: '600',
    color: colors.textSecondary,
  },
  filterTextActive: {
    color: '#ffffff',
  },
  list: {
    padding: wp('4%'),
  },
});

export default RequestsScreen;
