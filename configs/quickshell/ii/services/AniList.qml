pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    id: root
    
    readonly property string url: "https://graphql.anilist.co"

    function search(queryText, type = "ANIME", callback) {
        const query = "query ($search: String, $type: MediaType) {" +
          "Page (page: 1, perPage: 10) {" +
            "media (search: $search, type: $type) {" +
              "id " +
              "title { romaji english native } " +
              "coverImage { large } " +
              "bannerImage " +
              "description(asHtml: false) " +
              "averageScore " +
              "genres " +
              "status " +
              "episodes " +
              "chapters " +
            "} " +
          "} " +
        "}";

        const variables = {
            search: queryText,
            type: type
        };

        const xhr = new XMLHttpRequest();
        xhr.open("POST", root.url);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("Accept", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    callback(response.data.Page.media);
                } else {
                    console.error("AniList API Error:", xhr.status, xhr.responseText);
                    callback([]);
                }
            }
        };

        xhr.send(JSON.stringify({
            query: query,
            variables: variables
        }));
    }
}
