(function () {
  // Render donation QR code (encodes a zcash: payment URI)
  var qrContainer = document.getElementById("qr");
  if (qrContainer && typeof qrcode === "function") {
    var address = qrContainer.dataset.address;
    var qr = qrcode(0, "M");
    qr.addData("zcash:" + address);
    qr.make();
    qrContainer.innerHTML = qr.createSvgTag({ scalable: true, margin: 0 });
  }

  // Copy address to clipboard
  var copyBtn = document.getElementById("copy");
  var addressEl = document.getElementById("address");
  if (copyBtn && addressEl) {
    copyBtn.addEventListener("click", function () {
      navigator.clipboard.writeText(addressEl.textContent.trim()).then(function () {
        copyBtn.textContent = "Copied!";
        setTimeout(function () {
          copyBtn.textContent = "Copy";
        }, 2000);
      });
    });
  }

  var yearEl = document.getElementById("year");
  if (yearEl) {
    yearEl.textContent = new Date().getFullYear();
  }
})();
