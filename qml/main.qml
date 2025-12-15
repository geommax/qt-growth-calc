import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts

ApplicationWindow {
    id: root
    visible: true
    width: 1200
    height: 800
    title: "Growth Pattern Calculator"

    color: "#f5f5f5"

    // Main layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Header
        Text {
            text: "Growth Pattern Calculator"
            font.pixelSize: 28
            font.bold: true
            color: "#333333"
        }

        // Control Panel
        Frame {
            Layout.fillWidth: true
            background: Rectangle {
                color: "#ffffff"
                border.color: "#e0e0e0"
                border.width: 1
                radius: 4
            }

            RowLayout {
                anchors.fill: parent
                spacing: 20

                // Base Input
                ColumnLayout {
                    spacing: 8
                    Label {
                        text: "Base (B):"
                        font.weight: Font.Bold
                        color: "#333333"
                    }
                    TextField {
                        id: baseInput
                        text: calculator.base.toFixed(2)
                        placeholderText: "Enter base value"
                        Layout.preferredWidth: 120
                        validator: DoubleValidator { bottom: 0.1; decimals: 5 }
                        onEditingFinished: {
                            let val = parseFloat(text)
                            if (!isNaN(val) && val > 0) {
                                calculator.base = val
                            }
                        }
                        enabled: !calculator.isCalculating
                        background: Rectangle {
                            border.color: baseInput.enabled ? "#cccccc" : "#e0e0e0"
                            border.width: 1
                            radius: 3
                            color: baseInput.enabled ? "#ffffff" : "#f9f9f9"
                        }
                    }
                }

                // Exponent Input
                ColumnLayout {
                    spacing: 8
                    Label {
                        text: "Exponent (E):"
                        font.weight: Font.Bold
                        color: "#333333"
                    }
                    TextField {
                        id: exponentInput
                        text: calculator.exponent.toString()
                        placeholderText: "Enter exponent value"
                        Layout.preferredWidth: 120
                        validator: IntValidator { bottom: 1; top: 100 }
                        onEditingFinished: {
                            let val = parseInt(text)
                            if (!isNaN(val) && val >= 1) {
                                calculator.exponent = val
                            }
                        }
                        enabled: !calculator.isCalculating
                        background: Rectangle {
                            border.color: exponentInput.enabled ? "#cccccc" : "#e0e0e0"
                            border.width: 1
                            radius: 3
                            color: exponentInput.enabled ? "#ffffff" : "#f9f9f9"
                        }
                    }
                }

                // Spacer
                Item {
                    Layout.fillWidth: true
                }

                // Calculate Button
                Button {
                    text: calculator.isCalculating ? "Calculating..." : "Calculate"
                    enabled: !calculator.isCalculating
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 40

                    onClicked: calculator.startCalculation()

                    background: Rectangle {
                        color: parent.enabled ? "#4CAF50" : "#cccccc"
                        radius: 4
                        border.color: parent.enabled ? "#45a049" : "#999999"
                        border.width: 1
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Bold
                    }
                }

                // Stop Button
                Button {
                    text: "Stop"
                    enabled: calculator.isCalculating
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40

                    onClicked: calculator.stopCalculation()

                    background: Rectangle {
                        color: parent.enabled ? "#f44336" : "#cccccc"
                        radius: 4
                        border.color: parent.enabled ? "#da190b" : "#999999"
                        border.width: 1
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Bold
                    }
                }
            }
        }

        // Chart and Results Layout
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            // Chart
            Frame {
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    color: "#ffffff"
                    border.color: "#e0e0e0"
                    border.width: 1
                    radius: 4
                }

                ChartView {
                    id: chartView
                    anchors.fill: parent
                    backgroundColor: "#ffffff"
                    legend.alignment: Qt.AlignBottom
                    legend.labelColor: "#333333"
                    animationOptions: ChartView.SeriesAnimations

                    ValueAxis {
                        id: axisX
                        min: 0
                        max: Math.max(calculator.exponent, 1)
                        titleText: "Step"
                        labelsColor: "#666666"
                        titleColor: "#333333"
                    }

                    ValueAxis {
                        id: axisY
                        min: 0
                        max: 100
                        titleText: "Value"
                        labelsColor: "#666666"
                        titleColor: "#333333"
                    }

                    LineSeries {
                        id: linearSeries
                        name: "Linear Growth (B × E)"
                        axisX: axisX
                        axisY: axisY
                        color: "#2196F3"
                        width: 2
                    }

                    LineSeries {
                        id: exponentialSeries
                        name: "Exponential Growth (B^E)"
                        axisX: axisX
                        axisY: axisY
                        color: "#FF9800"
                        width: 2
                    }
                }

                Connections {
                    target: calculator
                    function onLinearDataChanged() {
                        linearSeries.removePoints(0, linearSeries.count)
                        for (let i = 0; i < calculator.linearData.length; i++) {
                            linearSeries.append(calculator.linearData[i].x, calculator.linearData[i].y)
                        }
                        // Auto-adjust Y axis
                        if (calculator.linearData.length > 0) {
                            let maxLinear = Math.max(...calculator.linearData.map(p => p.y))
                            axisY.max = Math.max(maxLinear, 100)
                        }
                    }
                    function onExponentialDataChanged() {
                        exponentialSeries.removePoints(0, exponentialSeries.count)
                        for (let i = 0; i < calculator.exponentialData.length; i++) {
                            exponentialSeries.append(calculator.exponentialData[i].x, calculator.exponentialData[i].y)
                        }
                        // Auto-adjust Y axis
                        if (calculator.exponentialData.length > 0) {
                            let maxExp = Math.max(...calculator.exponentialData.map(p => p.y))
                            axisY.max = Math.max(maxExp, 100)
                        }
                    }
                }
            }

            // Results Panel
            Frame {
                Layout.preferredWidth: 280
                Layout.fillHeight: true
                background: Rectangle {
                    color: "#ffffff"
                    border.color: "#e0e0e0"
                    border.width: 1
                    radius: 4
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 15

                    // Title
                    Text {
                        text: "Results"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    // Current Step
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Label {
                            text: "Current Step:"
                            font.weight: Font.Bold
                            color: "#555555"
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            color: "#f9f9f9"
                            border.color: "#e0e0e0"
                            border.width: 1
                            radius: 3
                            Text {
                                anchors.fill: parent
                                anchors.margins: 8
                                text: calculator.currentStep
                                wrapMode: Text.WordWrap
                                color: "#333333"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignTop
                            }
                        }
                    }

                    // Linear Result
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Label {
                            text: "Linear Result:"
                            font.weight: Font.Bold
                            color: "#2196F3"
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            color: "#E3F2FD"
                            border.color: "#2196F3"
                            border.width: 1
                            radius: 3
                            Text {
                                anchors.fill: parent
                                anchors.margins: 8
                                text: calculator.linearResult
                                color: "#1565C0"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                font.weight: Font.Bold
                            }
                        }
                    }

                    // Exponential Result
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        Label {
                            text: "Exponential Result:"
                            font.weight: Font.Bold
                            color: "#FF9800"
                        }
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            color: "#FFF3E0"
                            border.color: "#FF9800"
                            border.width: 1
                            radius: 3
                            Text {
                                anchors.fill: parent
                                anchors.margins: 8
                                text: calculator.exponentialResult
                                color: "#E65100"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                font.weight: Font.Bold
                            }
                        }
                    }

                    // Spacer
                    Item {
                        Layout.fillHeight: true
                    }

                    // Status indicator
                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: calculator.isCalculating ? "#E8F5E9" : "#F5F5F5"
                        border.color: calculator.isCalculating ? "#4CAF50" : "#cccccc"
                        border.width: 1
                        radius: 3

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: calculator.isCalculating ? "#4CAF50" : "#999999"

                                SequentialAnimation on opacity {
                                    running: calculator.isCalculating
                                    loops: Animation.Infinite
                                    NumberAnimation {
                                        from: 1
                                        to: 0.5
                                        duration: 1000
                                    }
                                    NumberAnimation {
                                        from: 0.5
                                        to: 1
                                        duration: 1000
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: calculator.isCalculating ? "Calculating..." : "Ready"
                                color: calculator.isCalculating ? "#2E7D32" : "#666666"
                                font.weight: Font.Bold
                                font.pixelSize: 12
                            }
                        }
                    }
                }
            }
        }
    }
}
