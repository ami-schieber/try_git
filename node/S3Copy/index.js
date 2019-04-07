var AWS = require("aws-sdk");

exports.handler = (event, context, callback) => {
    var s3 = new AWS.S3();
    var sourceBucket = "ami-src";
    var destinationBucket = "ami-dst";
    var objectKey = event.Records[0].s3.object.key;
    var copySource = encodeURI(sourceBucket + "/" + objectKey);
    var copyParams = { Bucket: destinationBucket, CopySource:copySource, Key: objectKey };
    s3.copyObject(copyParams, function(err,data) {
        if (err) {
            console.log (err,err.stack);
        } else {
            console.log ("S3 Object copy successful.");
        }
    });
};