/*
    this file is a helper for App.js
    functions:
        renderLocations() - it renders an array {locations} of userClick locations with {styles} css styling
        renderDistanceTravelled() - it renders info about {distance} travelled with {styles} css styling
*/


import React from 'react';
import { // react components for native view display+ui
    Text, View,
    TouchableOpacity
} from 'react-native';
import { Marker } from "react-native-maps";


const renderLocations = ({ locations, styles }) => 
    locations.map((marker) => (
            <Marker {...marker} >
                <View style={styles.marker}>
                    <Text style={styles.text}>{marker.cost}</Text>
                </View>
            </Marker>
        )
    );




const renderDistanceTravelled = ({distance, styles}) => (
    <View style={styles.buttonContainer}>
        <TouchableOpacity style={[styles.bubble, styles.button]}>
            <Text style={styles.bottomBarContent}>
                {parseFloat(distance).toFixed(2)} km
          </Text>
        </TouchableOpacity>
    </View>
);


module.exports = { 
    renderLocations,
    renderDistanceTravelled
}