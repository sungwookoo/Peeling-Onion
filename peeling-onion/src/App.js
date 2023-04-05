import React, { useEffect, useState } from "react";
import "./App.css";
import axios from "axios";
import onion1 from "./img/onion.png";
import onion2 from "./img/glassonion.png";
import onion3 from "./img/hatonion.png";
import onion4 from "./img/muscle.png";
import onion5 from "./img/musikonion.png";
import onion6 from "./img/dongeunonion.png";
import onion7 from "./img/pinkonion.png";
import onion8 from "./img/suckonion.png";
import "animate.css";

function App() {
  const [isLeft, setIsLeft] = useState(true);
  useEffect(() => {
    const interval = setInterval(() => {
      setIsLeft((prev) => !prev);
    }, 1000);
    return () => clearInterval(interval);
  }, []);
  const logoClassName = `App-logo ${isLeft ? "spin-left animate__bounce" : "spin-right"} onion`;
  const logoBounceClassName = `App-logo ${
    isLeft ? "spin-left" : "spin-right animate__bounce"
  } onion`;

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
    <figure className="images" id="splash-device">
      <div className="device-image ios">
        <div className="device">
          {/* <img src="https://picsum.photos/1500/2500" /> */}
          <img src={onion1} className={logoBounceClassName} alt="React" />
          <img src={onion2} className={logoClassName} alt="React" />
          <img src={onion3} className={logoBounceClassName} alt="React" />
          <img src={onion4} className={logoClassName} alt="React" />
          <img src={onion5} className={logoBounceClassName} alt="React" />
          <img src={onion6} className={logoClassName} alt="React" />
          <img src={onion7} className={logoBounceClassName} alt="React" />
          <img src={onion8} className={logoClassName} alt="React" />

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
