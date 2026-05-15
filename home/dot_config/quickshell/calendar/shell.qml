import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    anchors {
        top: true
        right: true
    }

    margins {
        top: 36
        right: 16
    }

    focusable: true
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: gridWidth + contentMargin * 2
    implicitHeight: headerHeight + headerToWeekdaySpacing
        + weekdayHeight + weekdayToDatesSpacing + daysGridHeight
        + contentMargin * 2
    color: "transparent"

    property date shownDate: new Date()

    readonly property color calendarBorderColor: "#5a5a5a"
    readonly property color titleTextColor: "#ffffff"
    readonly property color buttonTextColor: "#e8eef8"
    readonly property color weekdayTextColor: "#f5f7fb"
    readonly property color todayWeekdayTextColor: "#66d9ff"
    readonly property color dayTextColor: "#e2e8f0"
    readonly property color todayBackgroundColor: "#0078d4"
    readonly property color todayTextColor: "#ffffff"
    readonly property color otherMonthTextColor: "#6f6f6f"
    readonly property int contentMargin: 16
    readonly property int headerHeight: 24
    readonly property int headerToWeekdaySpacing: 12
    readonly property int weekdayHeight: 18
    readonly property int weekdayToDatesSpacing: 4
    readonly property int dayCellWidth: 38
    readonly property int dayCellHeight: 36
    readonly property int dayColumnSpacing: 6
    readonly property int dayRowSpacing: 6
    readonly property int gridWidth: dayCellWidth * 7 + dayColumnSpacing * 6
    readonly property int daysGridHeight: dayCellHeight * 6 + dayRowSpacing * 5
    readonly property int headerTextOffset: 0
    readonly property int year: shownDate.getFullYear()
    readonly property int month: shownDate.getMonth()
    readonly property date today: new Date()
    readonly property var monthNames: [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]
    readonly property var weekdays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    readonly property int firstDay: new Date(year, month, 1).getDay()

    function cellDate(index) {
        return new Date(year, month, index - firstDay + 1);
    }

    function moveMonth(offset) {
        shownDate = new Date(year, month + offset, 1);
    }

    function isTodayWeekday(index) {
        return year === today.getFullYear()
            && month === today.getMonth()
            && index === today.getDay();
    }

    function closeCalendar() {
        root.visible = false;
        Qt.quit();
    }

    HyprlandFocusGrab {
        id: focusGrab

        active: true
        windows: [root]
        onCleared: root.closeCalendar()
    }

    Rectangle {
        id: card

        anchors.fill: parent
        radius: 0
        color: "#202020"
        border.color: root.calendarBorderColor
        border.width: 1
        focus: true

        Component.onCompleted: forceActiveFocus()

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape || event.key === Qt.Key_Q) {
                event.accepted = true;
                root.closeCalendar();
            } else if (event.key === Qt.Key_K) {
                event.accepted = true;
                root.moveMonth(-1);
            } else if (event.key === Qt.Key_J) {
                event.accepted = true;
                root.moveMonth(1);
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.contentMargin
            spacing: root.headerToWeekdaySpacing

            Item {
                Layout.preferredWidth: root.gridWidth
                Layout.minimumWidth: root.gridWidth
                Layout.maximumWidth: root.gridWidth
                Layout.preferredHeight: root.headerHeight
                Layout.alignment: Qt.AlignLeft

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: root.headerTextOffset
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.monthNames[root.month] + " " + root.year
                    color: root.titleTextColor
                    font.pixelSize: 20
                    font.bold: true
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: root.dayColumnSpacing

                    Item {
                        width: root.dayCellWidth
                        height: root.headerHeight

                        Text {
                            anchors.centerIn: parent
                            text: "▲"
                            color: root.buttonTextColor
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.moveMonth(-1)
                        }
                    }

                    Item {
                        width: root.dayCellWidth
                        height: root.headerHeight

                        Text {
                            anchors.centerIn: parent
                            text: "▼"
                            color: root.buttonTextColor
                            font.pixelSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.moveMonth(1)
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: root.gridWidth
                Layout.minimumWidth: root.gridWidth
                Layout.maximumWidth: root.gridWidth
                Layout.alignment: Qt.AlignLeft
                spacing: root.weekdayToDatesSpacing

                GridLayout {
                    Layout.preferredWidth: root.gridWidth
                    Layout.minimumWidth: root.gridWidth
                    Layout.maximumWidth: root.gridWidth
                    Layout.preferredHeight: root.weekdayHeight
                    columns: 7
                    columnSpacing: root.dayColumnSpacing

                    Repeater {
                        model: root.weekdays

                        Text {
                            Layout.preferredWidth: root.dayCellWidth
                            Layout.preferredHeight: root.weekdayHeight
                            text: modelData
                            color: root.isTodayWeekday(index)
                                ? root.todayWeekdayTextColor : root.weekdayTextColor
                            font.pixelSize: 12
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                GridLayout {
                    Layout.preferredWidth: root.gridWidth
                    Layout.minimumWidth: root.gridWidth
                    Layout.maximumWidth: root.gridWidth
                    Layout.preferredHeight: root.daysGridHeight
                    columns: 7
                    rowSpacing: root.dayRowSpacing
                    columnSpacing: root.dayColumnSpacing

                    Repeater {
                        model: 42

                        Rectangle {
                            property date dateValue: root.cellDate(index)
                            property bool inCurrentMonth: dateValue.getMonth() === root.month
                                && dateValue.getFullYear() === root.year
                            property bool isToday: dateValue.getDate() === root.today.getDate()
                                && dateValue.getMonth() === root.today.getMonth()
                                && dateValue.getFullYear() === root.today.getFullYear()

                            Layout.preferredWidth: root.dayCellWidth
                            Layout.preferredHeight: root.dayCellHeight
                            radius: 0
                            color: isToday ? root.todayBackgroundColor : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: parent.dateValue.getDate()
                                color: parent.isToday ? root.todayTextColor
                                    : parent.inCurrentMonth
                                        ? root.dayTextColor : root.otherMonthTextColor
                                font.pixelSize: 14
                            }
                        }
                    }
                }
            }
        }
    }
}
