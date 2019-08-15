function varargout = SketchyWorld(varargin)
% SKETCHYWORLD MATLAB code for SketchyWorld.fig
%      SKETCHYWORLD, by itself, creates a new SKETCHYWORLD or raises the existing
%      singleton*.
%
%      H = SKETCHYWORLD returns the handle to a new SKETCHYWORLD or the handle to
%      the existing singleton*.
%
%      SKETCHYWORLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SKETCHYWORLD.M with the given input arguments.
%
%      SKETCHYWORLD('Property','Value',...) creates a new SKETCHYWORLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SketchyWorld_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SketchyWorld_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SketchyWorld

% Last Modified by GUIDE v2.5 23-Apr-2018 22:56:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SketchyWorld_OpeningFcn, ...
    'gui_OutputFcn',  @SketchyWorld_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
global Retrievalflag
Retrievalflag = 0;

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SketchyWorld is made visible.
function SketchyWorld_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SketchyWorld (see VARARGIN)

% Choose default command line output for SketchyWorld
addpath(genpath('photo'));
addpath('D:\Program Files\MATLAB\R2017b\toolbox\nnet\cnn')
addpath('interface')
addpath('material')

h = [ 150 35 90 16];
set(gcf,'Position',h)
% 
% set(hObject,'Units','pixels');
% figuresize=get(hObject,'Position');
% screensize=get(0,'screensize');
% set(gcf,'outerposition',[(screensize(3)-figuresize(3))/2,(screensize(4)-figuresize(4))/2,figuresize(3),figuresize(4)]);


global  myP2 myS mySampleIndex_tr net myImageNetID myCategory mymean
net = vgg19;
% load mydata
load mydatamean
myP2 = P2;
myS = S;
mySampleIndex_tr = SampleIndex_tr;
myImageNetID = ImageNetID;
myCategory = Category;
mymean = mymeans;
global touchflag stopdrawing
touchflag = 0;
stopdrawing = 0;
% clear anchor2 Category ImageNetID P2 rS SampleIndex_tr sigma2 sketch_centers Tr_mean;
[A,map]=imread('sketch.gif','gif','frame','all');
B1 = imread('retr1.png');
B2 = imread('retr2.png');
B3 = imread('retr3.png');
axes(handles.axes1);
for k=1:size(A,4)
    imshow(A(:,:,:,k),map);
    pause(0.08);
    if findobj == 0
        return
    end
end

imshow(B1);
pause(0.1);
imshow(B2);
pause(0.1);
imshow(B3);
touchflag = 1;
% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes SketchyWorld wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SketchyWorld_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global touchflag
if touchflag == 1
    run('Sketchy.m')
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all
% Hint: delete(hObject) closes the figure
