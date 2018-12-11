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
import { Marker } from "react-native-maps";


const renderButton = ({ name, onPressButton }) => (
    <TouchableOpacity onPress={onPressButton}>
        <Text style={styles.text}>
            {name}
        </Text>
    </TouchableOpacity>
);

class Waypoint extends React.Component {
    constructor(props){
        super(props);
        const { id, marker, deleteButtonAction } = this.props;

        this.state = {
            isShowingInfoButtons: false
        };
        this.id = id;
        this.deleteButton = (() =>
            deleteButtonAction(this.id)).bind(this);
        this.marker = marker;
        this.toggleInfoButtons = this.toggleInfoButtons.bind(this);
    }
    toggleInfoButtons(e){
        if (e.stopPropagation) e.stopPropagation();
        if (e.nativeEvent.stopImmediatePropagation) e.nativeEvent.stopImmediatePropagation();
        let isShowing = this.state.isShowingInfoButtons;
        this.setState({
            isShowingInfoButtons: !isShowing
        });
    }

    infoButtons(){
        return this.state.isShowingInfoButtons ? (
                renderButton({
                    name: 'delete', 
                    onPressButton: this.deleteButton})
        ) : null;
    }

    render(){
        return <Marker 
                    {...this.marker} 
                    onPress={this.toggleInfoButtons}>
            <View style={styles.marker}>
              <Text style={styles.text}>{this.marker.cost}</Text>
              {this.infoButtons()}
            </View>
          </Marker>;
    }
}

const renderLocations = ({ locations, deleteButtonAction }) =>
  locations.map((marker, id) => (
    <Waypoint
        key={`userMarker_${id}`} 
        id={id} 
        marker={marker}
        deleteButtonAction={deleteButtonAction}
    />));


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