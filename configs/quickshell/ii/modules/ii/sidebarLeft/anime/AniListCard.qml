import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.modules.common
import qs.modules.common.widgets
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    required property var media
    
    implicitHeight: mainLayout.implicitHeight + 20
    Layout.fillWidth: true
    radius: Appearance.rounding.normal
    color: Appearance.colors.colLayer2
    clip: true

    Process {
        id: aniCliProc
    }

    // Banner Image in background
    StyledImage {
        anchors.fill: parent
        source: root.media.bannerImage || ""
        opacity: 0.15
        fillMode: Image.PreserveAspectCrop
        visible: source != ""
    }

    ColumnLayout {
        id: mainLayout
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 10
        }
        spacing: 10

        RowLayout {
            spacing: 15
            Layout.fillWidth: true

            // Cover Image
            Rectangle {
                width: 80
                height: 120
                radius: Appearance.rounding.small
                clip: true
                color: Appearance.colors.colLayer3

                StyledImage {
                    anchors.fill: parent
                    source: root.media.coverImage.large
                    fillMode: Image.PreserveAspectCrop
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                // Title
                StyledText {
                    Layout.fillWidth: true
                    text: root.media.title.english || root.media.title.romaji
                    font.pixelSize: Appearance.font.pixelSize.large
                    font.weight: Font.Bold
                    color: Appearance.colors.colOnLayer2
                    wrapMode: Text.WordWrap
                }

                // Rating & Status
                RowLayout {
                    spacing: 10
                    MaterialSymbol {
                        text: "star"
                        iconSize: 14
                        color: "#FFD700"
                    }
                    StyledText {
                        text: (root.media.averageScore ? (root.media.averageScore / 10).toFixed(1) : "N/A") + " / 10"
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colSubtext
                    }
                    StyledText {
                        text: "•"
                        color: Appearance.colors.colSubtext
                    }
                    StyledText {
                        text: root.media.status
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colSubtext
                    }
                }

                // Genres
                Flow {
                    Layout.fillWidth: true
                    spacing: 5
                    Repeater {
                        model: root.media.genres.slice(0, 3)
                        delegate: Rectangle {
                            width: genreText.implicitWidth + 10
                            height: genreText.implicitHeight + 4
                            radius: 10
                            color: Appearance.colors.colSecondaryContainer
                            StyledText {
                                id: genreText
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: 10
                                color: Appearance.colors.colOnSecondaryContainer
                            }
                        }
                    }
                }
            }
        }

        // Description
        StyledText {
            Layout.fillWidth: true
            text: root.media.description ? root.media.description.replace(/<br>/g, "\n").replace(/<i>/g, "").replace(/<\/i>/g, "").substring(0, 180) + "..." : "No description available."
            font.pixelSize: Appearance.font.pixelSize.smaller
            color: Appearance.colors.colOnLayer2
            wrapMode: Text.WordWrap
            maximumLineCount: 3
            elide: Text.ElideRight
        }

        // Buttons
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            RippleButton {
                Layout.preferredHeight: 35
                Layout.fillWidth: true
                buttonRadius: Appearance.rounding.small
                colBackground: Appearance.colors.colPrimaryContainer

                contentItem: RowLayout {
                    anchors.centerIn: parent
                    spacing: 5
                    MaterialSymbol {
                        text: "play_arrow"
                        iconSize: 18
                        color: Appearance.colors.colOnPrimaryContainer
                    }
                    StyledText {
                        text: "Watch Now"
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colOnPrimaryContainer
                    }
                }
                onClicked: {
                    const title = root.media.title.english || root.media.title.romaji;
                    aniCliProc.exec(["kitty", "-e", "ani-cli", title]);
                }
            }

            RippleButton {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 35
                buttonRadius: Appearance.rounding.small
                colBackground: Appearance.colors.colLayer3

                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    text: "bookmark_border"
                    iconSize: 18
                    color: Appearance.colors.colOnLayer3
                }
            }
        }
    }
}
