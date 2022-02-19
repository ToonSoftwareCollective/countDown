import QtQuick 2.1
import qb.components 1.0

Tile {
    id                          : countDownTile
    
    property bool   activeMe    : false

    property int    days
    property int    hours
    property int    minutes
    property int    seconds
    
    property int    myInterval
    property variant    diff   : 0 // when I use type int there are issues with high year numbers
    
    property int    showValue1
    property string showWhat1   : ""
    property int    showValue2
    property string showWhat2   : ""
    property int    showValue3
    property string showWhat3   : ""
    property int    showValue4
    property string showWhat4   : ""
    
// ---------------------------------------------------------------------
    
    onVisibleChanged: {
        if (visible) {
            if (app.momentReached) {
                stage.openFullscreen(app.countDownScreenUrl);
            } else { 
                var now = Date.now()
                if (app.countDownUp == "Down") {
                    diff = Math.floor( ( app.countDownDateTimeInt - now ) / 1000 )
                    if ( diff > 0 ) {
                        myInterval = 100
                        activeMe = true
                    } else {
                        activeMe = false
                        if (app.momentName != "Count" ) {
                            app.momentName = "Count"
                            app.saveSettings()
                        }
                    }
                } else {
                    activeMe = true
                    myInterval = 1000
                }
            }
        }
    }

// -------------------------------------------------------------- Timers

    Timer {
        id                      : controlTimer
        interval                : myInterval
        running                 : activeMe
        repeat                  : true
        triggeredOnStart        : true
        onTriggered             : doit()
    }  

// ---------------------------------------------------------------------
    
    function doit() {
        
        var now = Date.now()
        if (app.countDownUp == "Down") {
            diff = Math.floor( ( app.countDownDateTimeInt - now ) / 1000 )
            if ( diff <= 0 ) {
                app.momentReached = true
                activeMe = false
                app.saveSettings()
                stage.openFullscreen(app.countDownScreenUrl);
            } else {
// interval is 1 second to : either sync on 10 seconds or count last seconds
                if ( ( (diff % 10) != 0 ) || (diff <= 120)  ){
                    myInterval = 500
                } else {
                    myInterval = 10000
                }
                days     =  ( diff ) / 60 / 60 / 24
                hours    =  ( diff ) / 60 / 60         - days * 24
                minutes  =  ( diff ) / 60              - days * 24 * 60        - hours * 60
                seconds  =  ( diff )                   - days * 24 * 60 * 60   - hours * 60 * 60   - minutes * 60
                if (days == 1)      { showWhat1="dag" }     else { showWhat1 ="dagen" }
                showValue1=days
                 if (hours == 1)    { showWhat2="uur" }    else { showWhat2 ="uren" }               
                showValue2=hours
                if (minutes == 1)   { showWhat3="minuut" }  else { showWhat3 ="minuten" }              
                showValue3=minutes
                if (seconds == 1)   { showWhat4="seconde" }  else { showWhat4 ="seconden" }        
                showValue4=seconds
            }
        } else {
            diff = Math.floor( ( now - app.countDownDateTimeInt ) / 1000 )
            
            if (diff > 0 ) {
            
                if ( ( diff % 10) != 0  ){
                    myInterval = 500
                } else {
                    myInterval = 10000
                }

                days     =  ( diff ) / 60 / 60 / 24
                hours    =  ( diff ) / 60 / 60         - days * 24
                minutes  =  ( diff ) / 60              - days * 24 * 60        - hours * 60
                seconds  =  ( diff )                   - days * 24 * 60 * 60   - hours * 60 * 60   - minutes * 60
                if (days == 1)      { showWhat1="dag" }     else { showWhat1 ="dagen" }
                showValue1=days
                 if (hours == 1)    { showWhat2="uur" }     else { showWhat2 ="uren" }               
                showValue2=hours
                if (minutes == 1)   { showWhat3="minuut" }  else { showWhat3 ="minuten" }              
                showValue3=minutes
                if (seconds == 1)   { showWhat4="seconde" }  else { showWhat4 ="seconden" }        
                showValue4=seconds
            } else {
                if  ( diff > - 20) {
                    myInterval = 500
                } else {
                    myInterval = 10000
                }
            }
        }
    }

// --------------------------------------------------- Setup Screen

    YaLabel {
        id                      : countDownScreen
        buttonText              : ""
        height                  : parent.height
        width                   : parent.height
        buttonActiveColor       : buttonSelectedColor
        buttonHoverColor        : buttonSelectedColor
        buttonSelectedColor     : (dimState) ? "black"  : "white"
        buttonBorderColor       : (dimState) ? "lightgrey" : "black"
        buttonBorderWidth       : 1
        selected                : true
        hoveringEnabled         : false
        enabled                 : true
        textColor               : "black"
        anchors {
            verticalCenter      : parent.verticalCenter
            horizontalCenter    : parent.horizontalCenter
        }
        onClicked: {
            stage.openFullscreen(app.countDownScreenUrl);
        }
    }

    Text {
        id                  : title
        text                : app.momentName
        color               : (activeMe && diff <= 120 && app.countDownUp == "Down" ) ? "red" : (dimState) ? "lightgrey" : "black"
        anchors {
            top             : parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 5 : 3
        }
        font.pixelSize      : isNxt ? 30 : 24
        font.bold           : (diff <= 120)
        visible             : true
    }

    Text {
        id                  : setup
        text                : "Setup"
        color               : (dimState) ? "lightgrey" : "black"
        anchors {
            top             : title.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 5 : 3
        }
        font.pixelSize      : isNxt ? 25 : 20
        visible             : ( ! activeMe )
    }

    Text {
        id                  : what1
        text                : showValue1 + " " + showWhat1
        color               : (dimState) ? "lightgrey" : "black"
        anchors {
            top             : title.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 5 : 3
        }
        font.pixelSize      : isNxt ? 25 : 20
        visible             : ( activeMe && diff > 120 )  || ( activeMe && diff > 0 && app.countDownUp == "Up" )
    }

    Text {
        id                  : what2
        text                : showValue2 + " " + showWhat2
        color               : (dimState) ? "lightgrey" : "black"
        anchors {
            top             : what1.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 5 : 3
        }
        font.pixelSize      : isNxt ? 25 : 20
        visible             : ( activeMe && diff > 120 )  || ( activeMe && diff > 0 && app.countDownUp == "Up" )
    }

    Text {
        id                  : what3
        text                : showValue3 + " " + showWhat3
        color               : (dimState) ? "lightgrey" : "black"
        anchors {
            top             : what2.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 5 : 3
        }
        font.pixelSize      : isNxt ? 25 : 20
        visible             : ( activeMe && diff > 120 )  || ( activeMe && diff > 0 && app.countDownUp == "Up" )
    }

    Text {
        id                  : what4
        text                : showValue4 + " " + showWhat4
        color               : (dimState) ? "lightgrey" : "black"
        anchors {
            top             : what3.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 5 : 3
        }
        font.pixelSize      : isNxt ? 25 : 20
        visible             : ( activeMe && diff > 120 )  || ( activeMe && diff > 0 && app.countDownUp == "Up" )
    }


    Text {
        id                  : what120
        text                : diff
        color               : "red"
        anchors {
            top             : title.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin       : isNxt ? 10 : 8
        }
        font.pixelSize      : isNxt ? 100 : 60
        font.bold           : true
        visible             : ( activeMe && diff <= 120 && app.countDownUp == "Down" )
    }

}
