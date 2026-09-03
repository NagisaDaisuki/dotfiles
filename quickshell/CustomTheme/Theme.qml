pragma Singleton
import QtQuick

QtObject {
    // ===== Dynamic base from matugen =====
    // 这次不再写死深色，完全跟随 matugen 当前 mode（light / dark）
    property color background: "#fbf8ff"
    property color surface: "#edebf3"
    property color surface_container: "#edebf3"
    property color surface_container_high: "#e6e4eb"
    property color surface_container_highest: "#dedce4"

    // ===== Text =====
    property color on_background: "#1b1b21"
    property color on_surface: "#1b1b21"
    property color on_surface_variant: "#45464f"

    property color text: "#1b1b21"
    property color text_muted: "#45464f"
    property color foreground: "#1b1b21"

    // ===== Accents =====
    property color primary: "#424e84"
    property color on_primary: "#ffffff"
    property color primary_container: "#98a4e0"
    property color on_primary_container: "#00062a"

    property color secondary: "#4d5064"
    property color on_secondary: "#ffffff"
    property color secondary_container: "#a3a6bd"
    property color on_secondary_container: "#050819"

    property color tertiary: "#684761"
    property color on_tertiary: "#ffffff"
    property color tertiary_container: "#c39bb9"
    property color on_tertiary_container: "#170216"

    // ===== Common aliases =====
    property color accent: "#424e84"
    property color accent2: "#684761"
    property color border: "#6c6c75"
    property color outline: "#6c6c75"

    // ===== Error =====
    property color error: "#a6050f"
    property color on_error: "#ffffff"

    // ===== Optional translucent helpers =====
    property color glass_bg: Qt.rgba(
        background.r,
        background.g,
        background.b,
        0.78
    )

    property color glass_surface: Qt.rgba(
        surface.r,
        surface.g,
        surface.b,
        0.82
    )
}
