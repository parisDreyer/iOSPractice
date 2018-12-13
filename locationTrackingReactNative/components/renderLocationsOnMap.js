/*
    this file is a helper for App.js
    functions:
        renderLocations() - it renders an array {locations} of userClick locations with {styles} css styling
        renderDistanceTravelled() - it renders info about {distance} travelled with {styles} css styling
*/

import React from 'react';
import styles from '../css/styles'; // css json
import { // react components for native view display+ui
    Text, View,
    TouchableOpacity
} from 'react-native';
import { Marker, Callout } from "react-native-maps";


const renderButton = ({ name, onPressButton }) => (
    <TouchableOpacity onPress={onPressButton}>
        <Text style={styles.text}>{name}</Text>
    </TouchableOpacity>
);

class Waypoint extends React.Component {
    constructor(props){
        super(props);

        const { marker, deleteButtonAction } = this.props;
        this.state = {
            isShowingInfoButtons: false,
            marker: marker,
            textContent: marker ? String(marker.id) : ""
        };
        this.id = marker.id;
        this.deleteButton = (() =>
            deleteButtonAction(this.id)).bind(this);

        if(this.state.marker) console.log("waypoint markercoord", JSON.stringify(this.state.marker.coordinate));
        this.toggleInfoButtons = this.toggleInfoButtons.bind(this);
    }



    async toggleInfoButtons(){//e){
        //if (!!e.stopPropagation) e.stopPropagation();
        //if (!!e.nativeEvent.stopImmediatePropagation) e.nativeEvent.stopImmediatePropagation();
        let isShowing = this.state.isShowingInfoButtons;

        if(isShowing){
            this.deleteButton();
            this.setState({marker: null})
        }


        this.setState({
            isShowingInfoButtons: !isShowing,
            textContent: !isShowing ? 
                "delete" : 
                this.marker ? String(this.marker.id) : ""
        });
    }


    refresh = () =>
        this.toggleInfoButtons().then(() => this.forceUpdate());

    


    render(){
        return !!this.state.marker ? 
             <Marker
            key={this.key}
            id={this.id}
            coordinate={this.state.marker.coordinate}
            style={styles.marker}
            title={this.state.textContent}
            onCalloutPress={this.refresh}/> : null;
    }
}

const renderLocations = ({ locations, deleteButtonAction }) =>
    locations.map(m =>
        <Marker
            key={`userMarker_${m.id}`}
            coordinate={m.coordinate}
            style={styles.marker}
            title={`${m.id}`}
            onPress={() => deleteButtonAction(m.id)}
        />)
//   locations.map((m) => (!!m && !!m.coordinate?
//     <Waypoint
//         key={`userMarker_${m.id}`} 
//         id={m.id} 
//         marker={m}
//         deleteButtonAction={deleteButtonAction}
//     /> : null));


const renderDistanceTravelled = ({distance}) => (
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
};