(function() {
  var createStorageKey, host, uploadAttachment;

  document.addEventListener("trix-attachment-add", function(event) {
    var attachment;
    attachment = event.attachment;
    if (attachment.file) {
      return uploadAttachment(attachment);
    }
  });

  // Debug functions
  //
  var uploadComplete = function(event) {
    alert("Done - " + event.target.responseText);
  };

  var uploadFailed = function(event) {
    alert("There was an error" + event);
  };

  host = "https://shoshin-bucket.s3.amazonaws.com/";

  uploadAttachment = function(attachment) {
    var file, form, key, xhr;
    file = attachment.file;
    key = createStorageKey(file);
    form = new FormData;
    form.append("key", key);
    form.append("acl", "public-read");
    form.append("x-ignore-Content-Type", file.type);
    form.append("AWSAccessKeyId", "AKIAI2JMZHK4KESY3DIQ")
    form.append("policy", "eyJleHBpcmF0aW9uIjoiMjAyMC0xMi0wMVQxMjowMDowMC4wMDBaIiwiY29uZGl0aW9ucyI6W3siYnVja2V0Ijoic2hvc2hpbi1idWNrZXQifSxbInN0YXJ0cy13aXRoIiwiJGtleSIsInVwbG9hZHMvYXR0YWNobWVudHMvIl0seyJhY2wiOiJwdWJsaWMtcmVhZCJ9XX0=");
    form.append("signature", "VOPyMOJOQgiJsVbvMqsBzX0l3es=");
    form.append("file", file);
    xhr = new XMLHttpRequest;
    xhr.addEventListener("load", uploadComplete, false);
    xhr.addEventListener("error", uploadFailed, false);
    xhr.upload.onprogress = function(event) {
      var progress;
      progress = event.loaded / event.total * 100;
      return attachment.setUploadProgress(progress);
    };
    xhr.onload = function() {
      var href, url;
      if (xhr.status === 204) {
        url = href = host + key;
        return attachment.setAttributes({
          url: url,
          href: href
        });
      }
    };
    xhr.open("POST", host, true);
    return xhr.send(form);
  };

  createStorageKey = function(file) {
    var date, day, time;
    date = new Date();
    day = date.toISOString().slice(0, 10);
    time = date.getTime();
    return "uploads/attachments/" + day + "/" + time + "-" + file.name;
  };
}).call(this);
