import haversine from "haversine";

// calcs distance between two gps coords taking into account the curve of the earth
const calcDistance = (newLatLng, prevLatLng) => haversine(prevLatLng, newLatLng) || 0;

/*
    // here is the reference data structure that shows what graph we're dealing with
    let Edge = {
        u: nil,
        v: nil,
        w: nil
    }
    let Node = {
        x: nil,
        y: nil,
        n: nil
    }
*/



function arrayWithoutEl(array, el, limit = 1){
    let count = 0
    let newArr = [];
    for(let i = 0; i < array.length; ++i){
        if(count < limit && array[i] === el) {
            count += 1;
        } else newArr.push(array[i]);
    }
    return newArr;
}


// dijkstra's algorithm
// nodes is a hash of gps coords with arbitrary keys
// start is the node to start on
function tspDijkstras(nodes, start){
    console.log(JSON.stringify(nodes));
    let solution = [];
    let remaining = Object.keys(nodes);//arrayWithoutEl(Object.keys(nodes), start, 1);
    let u = start;
    while(remaining.length > 0){
        let [best, best_cost] = [undefined, undefined];
        for(let i = 0; i < remaining.length; ++i){ // find the next best node to go to
            let v = remaining[i];
            let tmp =  calcDistance(nodes[u], nodes[v]);
            
            if (best === undefined || tmp < best_cost)
                [best, best_cost] = [v, tmp];
        }
        u = best; // reassign the current node in the network
        remaining = arrayWithoutEl(remaining, best, 1);
        solution.push(u);
    }
    // solution.push(start); // the endpoint is the startpoint
    return solution;
}





// https://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array/6274398
function shuffle(a) {
    for (let i = a.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
}





module.exports = { calcDistance, tspDijkstras, shuffle };