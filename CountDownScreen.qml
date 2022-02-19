import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

Screen {
    id                          : countDownScreen
    screenTitle                 : qsTr(me)

// ---------------------------------------------------------------------

    property string me          : ""

    property bool test          : false
    property bool testButtonEnabled : false
        
    property string activeColor : "green"
    property string activeTextColor : "white"

    property int buttonWidth    : isNxt ? 115 : 92
    property int buttonHeight   : isNxt ? 40 : 32
    property string fixedButtonColor : "lime"

    property int yyyy
    property int mm
    property int dd
    property int hh
    property int min
    property int sec

    property bool editting : false

    property variant screenColors   : ["lightgrey","blue","white","red","yellow","green","lime","magenta","orange"]
    property variant textColors     : [            "blue","white","red","yellow","green","lime","magenta","orange","lightgrey"]
    property int    colorIndex      : 0
    property int screenSizeFactor   : 1 
    property bool screenIncrease    : true


    property bool keyBoardEnabled   : false
    property int verticalScaling    : 1
    property string soort: "hh"  // yyyy, mm, dd, hh, min, sec
    
// ------------------------------------------------ some handy functions

    function right(str, chr)
    {
        return str.slice(str.length-chr,str.length);
    }
    
// ---------------------------------------------------------------------
    
    onVisibleChanged: {
        me = "Count "+ app.countDownUp + " Setup"
        if (visible) {
            keyBoardEnabled = false
            if ( ! editting) { 
// I show up and do not come back from editting a field
// so I come from the tile and need to set some variables
                countDownUpToggle.isSwitchedOn = ( app.countDownUp == "Up" );
                activeColor = "green"
                yyyy = app.countDownDateTime.slice(0,4)
                mm   = app.countDownDateTime.slice(5,7)
                dd   = app.countDownDateTime.slice(8,10)
                hh   = app.countDownDateTime.slice(11,13)
                min  = app.countDownDateTime.slice(14,16)
                sec  = app.countDownDateTime.slice(17,19)
                momentNameInput.buttonText = app.momentName
                yyyyInput.buttonText = right('0000' + yyyy ,4)
                mmInput.buttonText   = right('0' + mm ,2)
                ddInput.buttonText   = right('0' + dd ,2)
                hhInput.buttonText   = right('0' + hh ,2)
                minInput.buttonText  = right('0' + min,2)
                secInput.buttonText  = right('0' + sec,2)
                btn1.buttonText  = "Middernacht"
                btn2.buttonText  = "Kerstmis"
                btn3.buttonText  = "Nieuw Jaar"
                btn4.buttonText  = "Valentijn"
                btn5.buttonText  = "Carnaval"
                btn6.buttonText  = "Pasen"
                btn7.buttonText  = "Sinterklaas"
                btn8.buttonText  = "Moederd.mei"      // 5  :: mei
                btn9.buttonText  = "Moederd.aug"      // 8  :: augustus
                btn10.buttonText = "Vaderd.mrt"      // 3  :: maart
                btn11.buttonText = "Vaderd.jun2"     // 62 :: juni 2e zondag
                btn12.buttonText = "Vaderd.jun3"     // 63 :: juni 3e zondag
                btn13.buttonText = "Zomertijd"
                btn14.buttonText = "Wintertijd"
                btn15.buttonText = "Halloween"
                btn16.buttonText = "Dierendag"
                btn17.buttonText = "Singles"
// button 18 is fixed test button
                testButtonEnabled  = ( app.countDownTile.activeMe && app.countDownUp == "Down" )
                if (testButtonEnabled) { btn18.buttonText = "Test" } else { btn18.buttonText = "Test Disabled" } 
            } else {
                editting = false
            }
        }
    }

// ---------------------------------------------------------------------

    Timer {
        id                      : blinkTimer
        interval                : 1000
        running                 : ( ( app.momentReached && visible) || test )
        repeat                  : true
        onTriggered             : {
            me = "Klik het scherm om te stoppen"
            colorIndex = (colorIndex + 1 ) % screenColors.length
            activeColor = screenColors[colorIndex]
            activeTextColor = textColors[colorIndex]
            if (colorIndex == 0) { screenIncrease = ! screenIncrease }
            if (screenIncrease ) { screenSizeFactor += 1 } else { screenSizeFactor -= 1 } 
        }
    }
    
// ---------------------------------------------------------------------

    function refreshScreen() {

        me = "Count "+ app.countDownUp + " Setup"

        countDownUpToggle.isSwitchedOn = ( app.countDownUp == "Up" );
        
// Check if input constructs a valid date
        var testcountDownDateTime = ('0000' + yyyy).slice(-4) + '-' + 
                                ('00' + mm).slice(-2) + '-' + 
                                ('00' + dd).slice(-2) + ' ' + 
                                ('00' + hh).slice(-2) + ':' + 
                                ('00' + min).slice(-2) + ':' + 
                                ('00' + sec).slice(-2)
        var date = new Date(testcountDownDateTime)
        if (date != "Invalid Date") {
//------- check if date is in the past because then we need to stop the tile timer     
            var now = Date.now()
            var testcountDownDateTimeInt = Date.parse(testcountDownDateTime+".000")
            var diff = Math.floor( ( testcountDownDateTimeInt - now ) / 1000 )
            if (diff <= 0 ) {
                app.countDownTile.activeMe = false
            }
//-------and now store the new data
            app.countDownDateTime = testcountDownDateTime
            app.countDownDateTimeInt = Date.parse(app.countDownDateTime+".000")
            app.saveSettings()
            momentNameInput.buttonText = app.momentName
            yyyyInput.buttonText = right('0000' + yyyy ,4)
            mmInput.buttonText   = right('0' + mm ,2)
            ddInput.buttonText   = right('0' + dd ,2)
            hhInput.buttonText   = right('0' + hh ,2)
            minInput.buttonText  = right('0' + min,2)
            secInput.buttonText  = right('0' + sec,2)

//------- check if date is in the future because then we need to start the tile timer     

            if (diff > 0 ) {
                app.countDownTile.activeMe = true
            }
            testButtonEnabled  = ( app.countDownTile.activeMe && app.countDownUp == "Down" )
            if (testButtonEnabled) { btn18.buttonText = "Test" } else { btn18.buttonText = "Test Disabled" } 
        }
    }
    
// ---------------------------------------------------------------------

    function saveMomentName(text) {
        if (text) {
//            if ( text.trim() != "" ) {
                    app.momentName = text.trim();
                    refreshScreen()
//            }
        }
    }

    function saveYYYY(text) {
        if (text) {
            if ( text.trim() != "" ) {
                if ( ( parseInt(text.trim()) >= 0 ) && ( parseInt(text.trim()) < 10000 ) ) {
                    yyyy = text.trim();
                    refreshScreen()
                }
            }
        }
    }
    
    function saveMM(text) {
        if (text) {
            if ( text.trim() != "" ) {
                if ( ( parseInt(text.trim()) > 0 ) && ( parseInt(text.trim()) < 13 ) ) {
                    mm = text.trim();
                    refreshScreen()
                }
            }
        }
    }
    
    function saveDD(text) {
        if (text) {
            if ( text.trim() != "" ) {
                if ( ( parseInt(text.trim()) > 0 ) && ( parseInt(text.trim()) < 32 ) ) {
                    dd = text.trim();
                    refreshScreen()
                }
            }
        }
    }
    
    function saveHH(text) {
        if (text) {
            if ( text.trim() != "" ) {
                if ( ( parseInt(text.trim()) >= 0 ) && ( parseInt(text.trim()) < 25 ) ) {
                    hh = text.trim();
                    refreshScreen()
                }
            }
        }
    }
    
    function saveMIN(text) {
        if (text) {
            if ( text.trim() != "" ) {
                if ( ( parseInt(text.trim()) >= 0 ) && ( parseInt(text.trim()) < 60 ) ) {
                    min = text.trim();
                    refreshScreen()
                }
            }
        }
    }
    
    function saveSEC(text) {
        if (text) {
            if ( text.trim() != "" ) {
                if ( ( parseInt(text.trim()) >= 0 ) && ( parseInt(text.trim()) < 60 ) ) {
                    sec = text.trim();
                    refreshScreen()
                }
            }
        }
    }

// ---------------------------------------------------------------------

// Date calculations for preconfigured buttons

    function easterdate( y ) {

// thanks to : https://stackoverflow.com/questions/1284314/easter-date-in-javascript

        var date, a, b, c, m, d;

        // Instantiate the date object.
        date = new Date;

        // Set the timestamp to midnight.
        date.setHours( 0, 0, 0, 0 );

        // Set the year.
        date.setFullYear( y );

        // Find the golden number.
        a = y % 19;

        // Choose which version of the algorithm to use based on the given year.
        b = ( 2200 <= y && y <= 2299 ) ?
            ( ( 11 * a ) + 4 ) % 30 :
            ( ( 11 * a ) + 5 ) % 30;

        // Determine whether or not to compensate for the previous step.
        c = ( ( b === 0 ) || ( b === 1 && a > 10 ) ) ?
            ( b + 1 ) :
            b;

        // Use c first to find the month: April or March.
        m = ( 1 <= c && c <= 19 ) ? 3 : 2;

        // Then use c to find the full moon after the northward equinox.
        d = ( 50 - c ) % 31;

        // Mark the date of that full moon—the "Paschal" full moon.
        date.setMonth( m, d );

        // Count forward the number of days until the following Sunday (Pasen).
        date.setMonth( m, d + ( 7 - date.getDay() ) );

        // Gregorian Western Pasen Sunday
        return date;

    }
    
    function calculate(what) {

        var now = new Date();

        var nowdd = right( '0' + String(now.getDate()) ,2 )
        var nowmm = right( '0' + String(now.getMonth() + 1) , 2 ) // January is 0!
        var nowyyyy = now.getFullYear();            

        switch(what) {
// Fixed dates
        case "Singles" :
        case "Sinterklaas" :
        case "Kerstmis" :
        case "Nieuw Jaar" :
        case "Valentijn" :
        case "Halloween" :
        case "Dierendag" :
            if (app.countDownUp == "Up") { nowyyyy = nowyyyy - 1 } // shift one year back 
            if (what == "Singles" )     { var MM = '11' ; var DD = '11' }
            if (what == "Sinterklaas" ) { var MM = '12' ; var DD = '05' }
            if (what == "Kerstmis" )    { var MM = '12' ; var DD = '25' }
            if (what == "Nieuw Jaar" )  { var MM = '01' ; var DD = '01' }
            if (what == "Valentijn" )   { var MM = '02' ; var DD = '14' }
            if (what == "Halloween" )   { var MM = '10' ; var DD = '31' }
            if (what == "Dierendag" )   { var MM = '10' ; var DD = '04' }
            if (( nowmm > MM ) || ( ( nowmm == MM ) && (nowdd >= DD ) ) ) {
                var dateString = (parseInt(nowyyyy) + 1) + '-' + MM + '-' + DD + ' 00:00:00'
            } else {
                var dateString = nowyyyy + '-' + MM + '-' + DD + ' 00:00:00'
            }
            var newdate = new Date(dateString)
            break;

// Tijd gerelateerd
        case "Middernacht" :
            var dateString = nowyyyy + '-' + nowmm + '-' + nowdd + ' 00:00:00'
            var newdate = new Date(dateString)
            if (app.countDownUp == "Down") { newdate.setDate(newdate.getDate()+1); } // we want to count down 
            break;

// Pasen gerelateerd
        case "Pasen" :
            var newdate = easterdate(nowyyyy)
            if ( (now - newdate) > 0) {
                if ( app.countDownUp == "Down" ) { newdate = easterdate(parseInt(nowyyyy) + 1) }
            } else {
                if ( app.countDownUp == "Up" ) { newdate = easterdate(parseInt(nowyyyy) - 1) }
            }
            break;
        case "Carnaval" :
// Carnaval start op zondag voor Aswoensdag, de start van de 40 dagentijd waarbij zondagen niet meetellen
// M.a.w. elke week levert niet 7 maar slechts 6 dagen. 
// 6 volle weken leveren 36 Vastendagen ofwel 6 x 7 = 42 echte dagen
// je hebt dan nog 4 extra Vastendagen nodig om op 40 Vastendagen te komen
// je hebt dan 46 echte dagen. De echte duur van de 40 dagentijd is 46 dagen.
// Als je dan terugrekent vanaf Pasen kom je op Aswoensdag
// Om op de zondag daarvoor terecht te komen heb je nog 3 extra dagen nodig.
// Zo kom je op 49 dagen voor Pasen.
            var newdate = easterdate(nowyyyy)
            newdate.setDate(newdate.getDate() - 49);
            if ( (now - newdate) > 0) {
                if ( app.countDownUp == "Down" ) { newdate = easterdate(parseInt(nowyyyy) + 1) ; newdate.setDate(newdate.getDate() - 49); }
           
            } else {
                if ( app.countDownUp == "Up" ) { newdate = easterdate(parseInt(nowyyyy) - 1) ; newdate.setDate(newdate.getDate() - 49); }
            }
            break;

// Zomertijd Wintertijd
        case "Zomertijd" :
            if (app.countDownUp == "Up") { nowyyyy = nowyyyy - 1 } // shift one year back 
            var dateString = nowyyyy + '-03-31 00:00:00'
            var newdate = new Date(dateString)
            while (newdate.getDay() != 0) { newdate.setDate(newdate.getDate() - 1) }
            var newdatedd = newdate.getDay()
            if ( (nowmm > 3 ) || ( (nowmm == 3) && (nowdd >= newdatedd ) ) ) {
                dateString = (nowyyyy + 1) + '-03-31 00:00:00'
                newdate = new Date(dateString)
                while (newdate.getDay() != 0) { newdate.setDate(newdate.getDate() - 1) }
            }
            break;
        case "Wintertijd" :
            if (app.countDownUp == "Up") { nowyyyy = nowyyyy - 1 } // shift one year back 
            var dateString = nowyyyy + '-10-31 00:00:00'
            var newdate = new Date(dateString)
            while (newdate.getDay() != 0) { newdate.setDate(newdate.getDate() - 1) }
            var newdatedd = newdate.getDay()
            if ( (nowmm > 10 ) || ( (nowmm == 10) && (nowdd >= newdatedd ) ) ) {
                dateString = (nowyyyy + 1) + '-10-31 00:00:00'
                newdate = new Date(dateString)
                while (newdate.getDay() != 0) { newdate.setDate(newdate.getDate() - 1) }
            }
            break;

// Moederdagen en Vaderdagen
        case "Moederd.mei" :
            var dateString = nowyyyy + '-04-30 00:00:00'
            var newdate = new Date(dateString)
            var sundays = 0
            while (sundays < 2) {
                newdate.setDate(newdate.getDate() + 1) 
                if (newdate.getDay() == 0) { sundays +=1 }
            }

            if ( (now - newdate) > 0) {
                if (app.countDownUp == "Down") { 
                    dateString = (nowyyyy + 1 ) + '-04-30 00:00:00'
                    newdate = new Date(dateString)
                    sundays = 0
                    while (sundays < 2) {
                        newdate.setDate(newdate.getDate() + 1) 
                        if (newdate.getDay() == 0) { sundays +=1 }
                    }
                }
            } else {
                if (app.countDownUp == "Up") { 
                    dateString = (nowyyyy - 1 ) + '-04-30 00:00:00'
                    newdate = new Date(dateString)
                    sundays = 0
                    while (sundays < 2) {
                        newdate.setDate(newdate.getDate() + 1) 
                        if (newdate.getDay() == 0) { sundays +=1 }
                    }
                }
            }
            break;
        case "Moederd.aug" :
            var dateString = nowyyyy + '-08-15 00:00:00'
            var newdate = new Date(dateString)

            if ( (now - newdate) > 0) {
                if (app.countDownUp == "Down") { dateString = (parseInt(nowyyyy) + 1) + '-08-15 00:00:00' ; newdate = new Date(dateString) }
            } else {
                if (app.countDownUp == "Up") { dateString = (parseInt(nowyyyy) - 1) + '-08-15 00:00:00' ; newdate = new Date(dateString) }
            }
            break;

        case "Vaderd.jun2" :
        case "Vaderd.jun3" :
            if (what == "Vaderd.jun2" ) {var count = 2 } else { var count = 3} 
            var dateString = nowyyyy + '-05-31 00:00:00'
            var newdate = new Date(dateString)
            var sundays = 0
            while (sundays < count) {
                newdate.setDate(newdate.getDate() + 1) 
                if (newdate.getDay() == 0) { sundays +=1 }
            }

            if ( (now - newdate) > 0) {
                if (app.countDownUp == "Down") { 
                    dateString = (nowyyyy + 1 ) + '-05-31 00:00:00'
                    newdate = new Date(dateString)
                    sundays = 0
                    while (sundays < count) {
                        newdate.setDate(newdate.getDate() + 1) 
                        if (newdate.getDay() == 0) { sundays +=1 }
                    }
                }
            } else {
                if (app.countDownUp == "Up") { 
                    dateString = (nowyyyy - 1 ) + '-05-31 00:00:00'
                    newdate = new Date(dateString)
                    sundays = 0
                    while (sundays < count) {
                        newdate.setDate(newdate.getDate() + 1) 
                        if (newdate.getDay() == 0) { sundays +=1 }
                    }
                }
            }

/*
            var newdatedd = newdate.getDay()
            if ( (nowmm > 5 ) || ( (nowmm == 5) && (nowdd >= newdatedd ) ) ) {
                dateString = (nowyyyy + 1) + '-05-31 00:00:00'
                newdate = new Date(dateString)
                sundays = 0
                while (sundays < count) {
                    newdate.setDate(newdate.getDate() + 1) 
                    if (newdate.getDay() == 0) { sundays +=1 }
                }
            }
*/
            break;


        case "Vaderd.mrt" :
            var dateString = nowyyyy + '-03-19 00:00:00'
            var newdate = new Date(dateString)

            if ( (now - newdate) > 0) {
                if (app.countDownUp == "Down") { dateString = (parseInt(nowyyyy) + 1) + '-03-19 00:00:00' ; newdate = new Date(dateString) }
            } else {
                if (app.countDownUp == "Up") { dateString = (parseInt(nowyyyy) - 1) + '-03-19 00:00:00' ; newdate = new Date(dateString) }
            }
            break;
        }

        yyyy = newdate.getFullYear()
        mm = newdate.getMonth() + 1
        dd = newdate.getDate()
        hh = newdate.getHours()
        min = newdate.getMinutes()
        sec = newdate.getSeconds()

        app.momentName = what
        refreshScreen()

// when you are in another app and the counter went off and you set a new time and did not go back to the tiles screen the countdown does not start so here force it to start.        
        app.countDownTile.activeMe = true
    
    }

// ---------------------------------------------------------------------

    Rectangle {
    
        height                  : parent.height - 20
        width                   : parent.width - 40
        anchors {
            horizontalCenter    : parent.horizontalCenter
            verticalCenter      : parent.verticalCenter
        }
        color                   : activeColor

        Text {
            id                      : info1
            text                    : (app.countDownUp == "Down") ? "Kies of maak je eind moment\nWil je geen count down?\nMaak moment in het verleden\nKlik Test om te testen\nHome voor Exit/Save"
                                                                  : "Kies of maak je start moment\nWil je nog geen count up?\nMaak moment in de toekomst\nCount up start vanaf dan\nHome voor Exit/Save"
            color                   : "black"
            anchors {
                top                 : parent.top
                left                : parent.left
                leftMargin          : isNxt ? 5 : 4
                }
            font.pixelSize          : isNxt ? 25 : 17
        }

        Text {
            id                      : info2
            text                    : "Opmerking over tegeltje:\nhoeft niet op 1e scherm\nmag ook op ander scherm\nen is dan uit het zicht"
            color                   : "black"
            anchors {
                top                 : parent.top
                right               : parent.right
                rightMargin         : isNxt ? 5 : 4
                }
            font.pixelSize          : isNxt ? 25 : 17
        }

// ---- Count Down or Count Up ?

        OnOffToggle {
            id: countDownUpToggle
            height: 36
            backgroundColorKnob : "yellow"
            shadowColorKnob: "black"
            backgroundColorLeft: "red"
            backgroundColorRight: "red"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: isNxt ? 20 : 16
            }
            leftIsSwitchedOn: false
            onSelectedChangedByUser: {
                if (app.countDownUp == "Down") {
                    app.countDownUp = "Up"
                } else {
                    app.countDownUp = "Down"
                }
                refreshScreen()
            }
        }

// Moment name

        YaLabel {
            id                      : momentNameInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 260 : 208
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                horizontalCenter    : parent.horizontalCenter
                top                 : parent.top
                topMargin           : isNxt ? 60 : 48
            }
            onClicked: { editting = true ; qkeyboard.open("Moment", momentNameInput.buttonText, saveMomentName) }
        }

        YaLabel {
            id                      : yyyyInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 100 : 80
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                verticalCenter      : ddInput.verticalCenter
                right               : d1.left
                rightMargin         : isNxt ? 5 : 4
            }
            onClicked: { soort = "yyyy" ; keyBoardEnabled = true }
        }

        Text {
            id                      : d1
            text                    : "-"
            color                   : "black"
            anchors {
                verticalCenter      : ddInput.verticalCenter
                right               : mmInput.left
                rightMargin         : isNxt ? 5 : 4
                }
            font.pixelSize          : isNxt ? 60 : 36
        }

        YaLabel {
            id                      : mmInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 100 : 80
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                verticalCenter      : ddInput.verticalCenter
                right               : d2.left
                rightMargin         : isNxt ? 5 : 4
            }
            onClicked: { soort = "mm" ; keyBoardEnabled = true }
        }

        Text {
            id                      : d2
            text                    : "-"
            color                   : "black"
            anchors {
                verticalCenter      : ddInput.verticalCenter
                right               : ddInput.left
                rightMargin         : isNxt ? 5 : 4
                }
            font.pixelSize          : isNxt ? 60 : 36
        }

        YaLabel {
            id                      : ddInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 100 : 80
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                top                 : momentNameInput.bottom
                right               : parent.horizontalCenter
                rightMargin         : isNxt ? 20 : 16
                topMargin           : isNxt ? 60 : 48
            }
            onClicked: { soort = "dd" ; keyBoardEnabled = true }
        }

        YaLabel {
            id                      : hhInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 100 : 80
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                top                 : ddInput.top
                left                : parent.horizontalCenter
                leftMargin          : isNxt ? 20 : 16
            }
            onClicked: { soort = "hh" ; keyBoardEnabled = true }
        }


        Text {
            id                      : c1
            text                    : ":"
            color                   : "black"
            anchors {
                verticalCenter      : ddInput.verticalCenter
                left                : hhInput.right
                leftMargin          : isNxt ? 5 : 4
                }
            font.pixelSize          : isNxt ? 60 : 36
        }

        YaLabel {
            id                      : minInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 100 : 80
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                top                 : hhInput.top
                left                : c1.right
                leftMargin          : isNxt ? 5 : 4
            }
            onClicked: { soort = "min" ; keyBoardEnabled = true }
        }

        Text {
            id                      : c2
            text                    : ":"
            color                   : "black"
            anchors {
                verticalCenter      : ddInput.verticalCenter
                left                : minInput.right
                leftMargin          : isNxt ? 5 : 4
                }
            font.pixelSize          : isNxt ? 60 : 36
        }

        YaLabel {
            id                      : secInput
            height                  : isNxt ? 60 : 48
            width                   : isNxt ? 100 : 80
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : "white"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            textColor               : "black"
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 40 : 32
            anchors {
                top                 : minInput.top
                left                : c2.right
                leftMargin          : isNxt ? 5 : 4
            }
            onClicked: { soort = "sec" ; keyBoardEnabled = true }
        }

// ---------------------------------------------------------------------

        YaLabel {
            id                      : btn1
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : yyyyInput.bottom
                horizontalCenter    : yyyyInput.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn1.buttonText) }
        }

        YaLabel {
            id                      : btn2
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : mmInput.bottom
                horizontalCenter    : mmInput.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn2.buttonText) }
        }

        YaLabel {
            id                      : btn3
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : ddInput.bottom
                horizontalCenter    : ddInput.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn3.buttonText) }
        }

        YaLabel {
            id                      : btn4
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : hhInput.bottom
                horizontalCenter    : hhInput.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn4.buttonText) }
        }

        YaLabel {
            id                      : btn5
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : minInput.bottom
                horizontalCenter    : minInput.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn5.buttonText) }
        }

        YaLabel {
            id                      : btn6
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : secInput.bottom
                horizontalCenter    : secInput.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn6.buttonText) }

        }

// ---------------------------------------------------------------------

        YaLabel {
            id                      : btn7
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn1.bottom
                horizontalCenter    : btn1.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn7.buttonText) }
        }

        YaLabel {
            id                      : btn8
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn2.bottom
                horizontalCenter    : btn2.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn8.buttonText) }
        }

        YaLabel {
            id                      : btn9
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn3.bottom
                horizontalCenter    : btn3.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn9.buttonText) }
        }


        YaLabel {
            id                      : btn10
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn4.bottom
                horizontalCenter    : btn4.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn10.buttonText) }
        }
        
        YaLabel {
            id                      : btn11
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn5.bottom
                horizontalCenter    : btn5.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn11.buttonText) }
        }

        YaLabel {
            id                      : btn12
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn6.bottom
                horizontalCenter    : btn6.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn12.buttonText) }
        }


// ---------------------------------------------------------------------

        YaLabel {
            id                      : btn13
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn7.bottom
                horizontalCenter    : btn7.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn13.buttonText) }
        }

        YaLabel {
            id                      : btn14
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn8.bottom
                horizontalCenter    : btn8.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn14.buttonText) }
        }

        YaLabel {
            id                      : btn15
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn9.bottom
                horizontalCenter    : btn9.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn15.buttonText) }
        }

        YaLabel {
            id                      : btn16
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn10.bottom
                horizontalCenter    : btn10.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn16.buttonText) }
        }

        YaLabel {
            id                      : btn17
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : fixedButtonColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : "black"
            anchors {
                top                 : btn11.bottom
                horizontalCenter    : btn11.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: { calculate(btn17.buttonText) }
        }
        
        YaLabel {
            id                      : btn18
            buttonText              : ""
            height                  : buttonHeight
            width                   : buttonWidth
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : testButtonEnabled ? fixedButtonColor : "red"
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 15 : 12
            textColor               : testButtonEnabled ? "black" : "white"
            anchors {
                top                 : btn12.bottom
                horizontalCenter    : btn12.horizontalCenter
                topMargin           : isNxt ? 25 : 20
            }
            onClicked: {
                if (testButtonEnabled) { test = true }
            }
        }

// ---------------------------------------------------------------------

        visible                 : ( (! app.momentReached ) && ( ! test ) )

    }
    
// ---------------------------------------------------------------------

    Rectangle {
    
        height                  : parent.height + 20
        width                   : parent.width

        color                   : "black"
    
        YaLabel {
            id                      : reset
            buttonText              : app.momentName
            height                  : (parent.height - 20) * ( screenSizeFactor / 40 ) + (parent.height - 20) * 3 / 4
            width                   : (parent.width  - 40) * ( screenSizeFactor / 40 ) + (parent.width  - 40) * 3 / 4
            buttonActiveColor       : buttonSelectedColor
            buttonHoverColor        : buttonSelectedColor
            buttonSelectedColor     : activeColor
            buttonBorderColor       : "black"
            buttonBorderWidth       : 1
            selected                : true
            hoveringEnabled         : isNxt
            enabled                 : true
            pixelsizeoverride       : true
            pixelsizeoverridesize   : isNxt ? 80 : 64
            textColor               : activeTextColor
            anchors {
                horizontalCenter    : parent.horizontalCenter
                verticalCenter      : parent.verticalCenter
            }
            onClicked: {
                if (test) {
                    test = false 
                } else {
                    app.momentName = "Count"
                    app.momentReached = false
                    app.saveSettings()
                }
                me = "Count " + app.countDownUp + " Setup"
                activeColor = "green"
            }
        }
        visible                 : ( app.momentReached || test )
    }

    YaLabel {
        id                      : resetText
        buttonText              : "Klik om te stoppen"
        height                  : 80
        width                   : parent.width
        buttonActiveColor       : buttonSelectedColor
        buttonHoverColor        : buttonSelectedColor
        buttonSelectedColor     : "black"
        buttonBorderWidth       : 1
        selected                : true
        hoveringEnabled         : isNxt
        enabled                 : true
        pixelsizeoverride       : true
        pixelsizeoverridesize   : isNxt ? 30 : 24
        textColor               : "#111111"
        buttonBorderRadius      : 0
        anchors {
            top     : parent.top
            left    : parent.left
            topMargin  : -80
        }
        onClicked: {
            if (test) {
                test = false 
            } else {
                app.momentName = "Count"
                app.momentReached = false
                app.saveSettings()
            }
            me = "Count " + app.countDownUp + " Setup"
            activeColor = "green"
        }
        visible                 : ( (! keyBoardEnabled) && ( app.momentReached || test ) )
    }

// ---------------------------------------------------------------------

    Rectangle {
        id                      : integerKeyBoard
        height                  : parent.height - 20
        width                   : parent.width - 40
        anchors {
            horizontalCenter    : parent.horizontalCenter
            verticalCenter      : parent.verticalCenter
        }
        color                   : activeColor

        Text {
            id: pinTitleText
            anchors {
                bottom: pinKeyboard.top
//                bottomMargin: designElements.vMargin10
                bottomMargin: isNxt ? 25 : 20
                horizontalCenter: pinKeyboard.horizontalCenter
            }
            font {
                family: qfont.bold.name
                pixelSize: qfont.titleText
            }
            color: "black"
            text: soort === "yyyy"? "Geef nieuw jaar" : soort === "mm"? "Geef nieuwe maand" : soort === "dd"? "Geef nieuwe dag" : soort === "hh"? "Geef nieuw uur" : soort === "min"? "Geef nieuwe minuut" : soort === "sec"? "Geef nieuwe seconde" : ""
        }

        YaNumericKeyboard {
            id: pinKeyboard
            anchors.centerIn: parent
            buttonWidth: isNxt ? Math.round(60 * verticalScaling) : Math.round(45 * verticalScaling)
            buttonHeight: isNxt ? Math.round(50 * verticalScaling) : Math.round(40 * verticalScaling)
            buttonSpace: designElements.vMargin10
            maxTextLength: (soort === "yyyy") ? 4 : 2
            pinMode: false
            kbMode : 5
/*
// I keep these for reference

            onPinEntered: {
                app.log('onPinEntered--------'+soort)
                app.log("onPinEntered pinMode: "+pinMode)
                app.log("onPinEntered numberText: "+numberText)
                app.log("onPinEntered numberLength: "+numberLength)
                app.log("onPinEntered enteredPin: "+numberPin)
            }
            onDigitEntered: {
                app.log("onPinEntered pinMode: "+pinMode)
                app.log("onDigitEntered: "+numberText)
            }
            onNumberLengthChanged: {
                app.log("onPinEntered pinMode: "+pinMode)
                app.log("onNumberLengthChanged : "+numberText)
            }
*/
        }

        StandardButton {
            id: continueBtn
            anchors {
                top: pinKeyboard.bottom
                topMargin: pinKeyboard.buttonSpace * 3
                left: pinKeyboard.left
                right: pinKeyboard.right
            }
            text: ( pinKeyboard.numberText == "" ) ? "Return" : "Ok"
            primary: true
            visible: true
            onClicked: {
                if(soort === "yyyy") saveYYYY(pinKeyboard.numberText);
                if(soort === "mm") saveMM(pinKeyboard.numberText);
                if(soort === "dd") saveDD(pinKeyboard.numberText);
                if(soort === "hh") saveHH(pinKeyboard.numberText);
                if(soort === "min") saveMIN(pinKeyboard.numberText);
                if(soort === "sec") saveSEC(pinKeyboard.numberText);
                keyBoardEnabled = false
                pinKeyboard.numberText = ""
//                pinKeyboard.numberPin = ""
            }
        }

        visible                 : ( keyBoardEnabled )

    }
}
