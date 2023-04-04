import React from "react";
import "./App.css";
import axios from "axios";
import onion1 from "./img/onion1.png";
import onion2 from "./img/onion2.png";
import onion3 from "./img/onion3.png";

function App() {
  const downloadApk = async () => {
    try {
      const response = await axios.get(
        "/jenkins/job/fe-prod/lastSuccessfulBuild/artifact/build/app/outputs/flutter-apk/app-release.apk",
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
      <div className="device-image ios">
        <div className="device">
          {/* <img src="https://picsum.photos/1500/2500" /> */}
          <img src={onion1} className="App-logo onion" alt="React" />
          <img src={onion2} className="App-logo onion" alt="React" />
          <img src={onion3} className="App-logo onion" alt="React" />
          <img src={onion1} className="App-logo onion" alt="React" />
          <img src={onion2} className="App-logo onion" alt="React" />
          <img src={onion3} className="App-logo onion" alt="React" />

          {/* <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F5400%2F2023%2F01%2F18%2F0000210703_001_20230118124202158.jpg&type=sc960_832" /> */}
        </div>
      </div>
      <figcaption id="splash-message">
        <div className="message">
          <span className="app-icon"></span>
          <div className="copy">
            <span className="ellipsis book">양파를 보내 감동을 전달하세요</span>
            <br></br>
            <span className="m-3 ellipsis book">Send the onion with the message</span>
          </div>
        </div>
        <a>
          <button className="yanolja" onClick={handleClick}>
            Get Peeling Onion App
          </button>
        </a>
      </figcaption>
    </figure>
  );
}

export default App;
