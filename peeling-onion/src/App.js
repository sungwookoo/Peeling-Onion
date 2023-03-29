import React from "react";
import "./App.css";
import axios from "axios";

function App() {
  const downloadApk = async () => {
    try {
      const response = await axios.get(
        "https://jenkins.ssafy.shop/job/fe-prod/lastSuccessfulBuild/artifact/build/app/outputs/flutter-apk/app-release.apk",
        {
          responseType: "blob",
        }
      );

      const url = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", "app-release.apk");
      document.body.appendChild(link);
      link.click();
    } catch (error) {
      console.error("APK 다운로드에 실패했습니다:", error);
    }
  };

  const handleClick = async () => {
    await downloadApk();
  };

  return (
    <figure id="splash-device">
      <div class="device-image ios">
        <div class="device">
          {/* <span class="site-name"> Peeling Onion </span> */}
          <img src="https://picsum.photos/1500/2500" />
        </div>
      </div>
      <figcaption id="splash-message">
        <div class="message">
          <span class="app-icon"></span>
          <div class="copy">
            <span class="ellipsis book">메세지를 담은 양파를 보내 감동을 전달하세요</span> <br></br>
            <span class="m-3 ellipsis book">Send a message to convey your feelings</span>
            {/* <span class="ellipsis site-name">Smiling Dog Yoga.</span> */}
          </div>
        </div>
        <a>
          <button class="yanolja" onClick={handleClick}>
            Get our Peeling Onion App
          </button>
        </a>
      </figcaption>
    </figure>
  );
}

export default App;
