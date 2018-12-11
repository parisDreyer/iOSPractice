import React, {Component} from 'react';
import { // react components for native view display+ui
  Platform, View
} from 'react-native';
import MapView, { Marker, AnimatedRegion, Polyline } from "react-native-maps";
import styles from './css/styles'; // css json
import { // helper to display info about stuff on the map
  renderLocations,
  renderDistanceTravelled
} from './components/renderLocationsOnMap';
import {
  calcDistance, // used in componentDidMount() to calc distance user has travelled
  tspDijkstras // travelling salesperson dijksra's greedy solution
} from "./components/travellingSalespersonGPS";


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
          longitude,
          routeCoordinates: routeCoordinates.concat([newCoordinate]),
          distanceTravelled: distanceTravelled + calcDistance(newCoordinate, this.state.prevLatLng),
          prevLatLng: newCoordinate
        });
      },
      error => error,//console.log(error),
      { enableHighAccuracy: true, timeout: 20000, maximumAge: 1000 }
    );
  }


  componentWillUnmount() {
    navigator.geolocation.clearWatch(this.watchID);
  }

  // helper for handle press
   dupCoord = (coord) => ({
      coordinate: coord['coordinate'],
      latitude: coord['latitude'],
      longitude: coord['longitude'],
      cost: coord['cost']
    });
  // helper for handle press
  dupCoordinates = (coordinates) => coordinates.map(coord => this.dupCoord(coord))
  
  handlePress(e) {
    let lngth = this.state.markers.length + 1;

    // lat and long required as separate datums for react-native-maps polyline component
    
    const new_coord = e.nativeEvent.coordinate;
    const latitude = new_coord['latitude'];
    const longitude = new_coord['longitude'];
    // the new coordinate from the user click
    let start_coord = { 
      key: `marker_${lngth}_${Date.now()}`, 
      coordinate: {latitude, longitude },//e.nativeEvent.coordinate,
      latitude: latitude,
      longitude: longitude,
      cost: `${0}` };
      // the new array of coordinates with the new coordinate
      let newMarkers = this.dupCoordinates(this.state.markers);
      newMarkers.push(start_coord);

      
    // a hash of coordinates (e.g. a graph) to do travelling-salesperson route sorting on
    let coordinate_nodes = {};
    let all_data = {};

    let i = 0;
    while(i < newMarkers.length){
      coordinate_nodes[i] = newMarkers[i]['coordinate'];
      all_data[i] = newMarkers[i];
      i++;
    }


    
    // use travelling-salesperson solution to find good route to reach all coordinates
    let ideal_route = tspDijkstras(coordinate_nodes, i - 1)

    // reorder the this.state.markers coordinates array to show the ideal route
    // this markers array will then have polylines drawn in the order of the array

    console.log("ideal route:::::::::::", JSON.stringify(ideal_route));
    let ordered_markers = []
    for(let j = 0; j < ideal_route.length; ++j){
      let nxt = all_data[ideal_route[j]];

      ordered_markers.push({
        key: `marker_${j + 1}`,
        coordinate: nxt.coordinate,
        latitude: nxt.latitude,
        longitude: nxt.longitude,
        cost: `${0}`
      });
    }
    console.log("----------------THE COORDS----------------");
    console.log("-----------------------------------");
    console.log("coord!", JSON.stringify(ordered_markers)); // just so i can see for debuggin
    console.log("-----------------------------------");
    console.log("----------------THE COORDS----------------");
    // finally update the new state for the ordered markers to draw
    // polylines from
    this.setState({ markers: ordered_markers });


  }

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
          <Polyline coordinates={this.state.markers} strokeWidth={4}/>
        </MapView>
        {renderDistanceTravelled({ distance: this.state.distanceTravelled, styles: styles})}
      </View>
    );
  }
}

export default AnimatedMarkers;
