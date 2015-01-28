import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.XmlListModel 2.0

ApplicationWindow {
    title: qsTr("Qt Quick Controls Test")
    width: 640
    height: 480
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    toolBar: ToolBar {
        width: parent.width
        height: toolbarLayout.height + 10
        RowLayout {
            id: toolbarLayout
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: qsTr("Zoom")
            }
            Slider {
                id: zoom
                value: 0.5
                Layout.fillWidth: true
                implicitWidth: 100
            }
            Text {
                text: "Search"
            }
            TextField {
                id: search
                text: ""
                Layout.fillWidth: true
                implicitWidth: 100
            }
        }


    }

    SplitView {
        anchors.fill: parent
        TableView {
            id: table
            height: parent.height
            TableViewColumn { role: "title" }
            model: flickrModel
        }
        ScrollView {
            width: parent.width - table.width
            height: parent.height
            Image {
                id: image
                source: flickrModel.get(table.currentRow).source.replace("_s", "_b")
                fillMode: Image.PreserveAspectFit
                scale: zoom.value + 0.5
                anchors.centerIn: parent
            }
        }
    }

    statusBar: StatusBar {
        RowLayout {
            width: parent.width
            Text {
                text: image.source
                Layout.fillWidth: true
                elide: Text.ElideMiddle
            }
            ProgressBar {
                value: image.progress
            }
        }
    }

    XmlListModel {
        id: flickrModel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + search.text
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "source"; query: "media:thumbnail/@url/string()" }
    }
}
