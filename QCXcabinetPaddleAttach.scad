// Intermediate include-file to import paddle attachment from the paddle design
// The intermediate file avoids any naming conflicts between designs
// and defines two functions to be called in the cabinet design

use <MorsePaddlesV2Base.scad>
//include <MorsePaddlesV2rotationstopper.scad>

module QCXpaddleAttachment(){ // Attachment for paddle
    attachmentEXPORT();
};

module QCXpaddleStopper(){ // Rotation stopper for paddle parking
    rotlimitEXPORT();
};
temp=attachHeightEXPORT();
function QCXpaddleHeight() // Get total height of attachment
    =temp;
