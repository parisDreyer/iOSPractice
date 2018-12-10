import React, {Component} from 'react';
import { // react components for native view display+ui
  Platform, Text, View,
  TouchableOpacity
} from 'react-native';
import MapView, { Marker, AnimatedRegion, Polyline } from "react-native-maps";
import haversine from "haversine";
import styles from './css/styles'; // css json
import { // helper to display info about stuff on the map
  renderLocations,
  renderDistanceTravelled
} from './components/renderLocationsOnMap';


const LATITUDE = 29.95539;
const LONGITUDE = 78.07513;
const LATITUDE_DELTA = 0.009;
const LONGITUDE_DELTA = 0.009;

class AnimatedMarkers extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      markers: [], // track the positions of user clicks
      latitude: LATITUDE,
      longitude: LONGITUDE,
      routeCoordinates: [],
      distanceTravelled: 0,
      prevLatLng: {},
      coordinate: new AnimatedRegion({
        latitude: LATITUDE,
        longitude: LONGITUDE
      })
    };
    this.handlePress = this.handlePress.bind(this);
  }

  componentWillMount() {
    navigator.geolocation.getCurrentPosition(
      position => {},
      error => alert(error.message),
      {
        enableHighAccuracy: true,
        timeout: 20000,
        maximumAge: 1000
      }
    );
  }

  componentDidMount() {
    const { coordinate } = this.state;
    this.watchID = navigator.geolocation.watchPosition(
      position => {
        const { coordinate, routeCoordinates, distanceTravelled } = this.state;
        const { latitude, longitude } = position.coords;
        const newCoordinate = {
          latitude,
          longitude
        };

        if (Platform.OS === "android") {
          if (this.marker) {
            this.marker._component.animateMarkerToCoordinate(
              newCoordinate,
              500
            );
          }
        } else {
          coordinate.timing(newCoordinate).start();
        }

        this.setState({
          latitude,
          longituderouteCoordinates: routeCoordinates.concat([newCoordinate]),
          distanceTravelled:
            distanceTravelled + this.calcDistance(newCoordinate),
          prevLatLng: newCoordinate
        });
      },
      error => console.log(error),
      { enableHighAccuracy: true, timeout: 20000, maximumAge: 1000 }
    );
  }

  componentWillUnmount() {
    navigator.geolocation.clearWatch(this.watchID);
  }

  handlePress(e) {
    let lngth = this.state.markers.length + 1;
    this.setState({
      markers: [
        ...this.state.markers,
        {
          key: `marker_${lngth}`,
          coordinate: e.nativeEvent.coordinate,
          cost: `${0}`
        }
      ]
    });
  }

  calcDistance = newLatLng => {
    const { prevLatLng } = this.state;
    return haversine(prevLatLng, newLatLng) || 0;
  };

  getMapRegion = () => ({
    latitude: this.state.latitude,
    longitude: this.state.longitude,
    latitudeDelta: LATITUDE_DELTA,
    longitudeDelta: LONGITUDE_DELTA
  });

  // render animated marker for user's position
  currentPositionMarker() {
    return (
      <Marker.Animated
        ref={marker => {
          this.marker = marker;
        }}
        coordinate={this.state.coordinate}
      />
    );
  }

  render() {
    return (
      <View style={styles.container}>
        <MapView
          style={styles.map}
          showsUserLocation
          followsUserLocation
          loadingEnabled
          region={this.getMapRegion()}
          onPress={this.handlePress}
        >
          {this.currentPositionMarker()}
          <Polyline coordinates={this.state.routeCoordinates} strokeWidth={5} />
          {renderLocations({ locations: this.state.markers, styles: styles })}
        </MapView>
        {renderDistanceTravelled({ distance: this.state.distanceTravelled, styles: styles})}
      </View>
    );
  }
}

export default AnimatedMarkers;
