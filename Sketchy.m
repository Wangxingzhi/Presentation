function varargout = Sketchy(varargin)
% SKETCHY MATLAB code for Sketchy.fig
%      SKETCHY, by itself, creates a new SKETCHY or raises the existing
%      singleton*.
%
%      H = SKETCHY returns the handle to a new SKETCHY or the handle to
%      the existing singleton*.
%
%      SKETCHY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SKETCHY.M with the given input arguments.
%
%      SKETCHY('Property','Value',...) creates a new SKETCHY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sketchy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sketchy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sketchy

% Last Modified by GUIDE v2.5 16-Jun-2018 21:13:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sketchy_OpeningFcn, ...
    'gui_OutputFcn',  @Sketchy_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Sketchy is made visible.
function Sketchy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sketchy (see VARARGIN)
% Choose default command line output for Sketchy
global x0 y0 init_x init_y width height
global ButtonDown Pattern
global switch_flag pause_time mydrawing
global indx
global pagenum
global Drawing Drawing0 constant
Pattern = 0;
mydrawing = 0;
pause_time = 0;
Drawing0 = 1024;
pagenum = 1;
switch_flag = 0;
ButtonDown = 0;
x0 = 1;
y0 = 1;
init_x = 49;
init_y = 94;
width = 451;
height = 451;
constant = 255 * width * height;
% Update handles structure
set(handles.drawingboard,'XTick', []);% 清除X轴的记号点
set(handles.drawingboard,'YTick', []);% 清除Y轴的记号点
set(handles.drawingboard,'XColor','white');% 设置X轴为白色
set(handles.drawingboard,'YColor','white');% 设置Y轴为白色
axes(handles.drawingboard);
axis([0,width,0,height]);
axis fill
hold on
set(handles.label1,'visible','off');
set(handles.label2,'visible','off');
set(handles.label3,'visible','off');
% t = timer('TimerFcn', {@timercallback, handles}, 'ExecutionMode', 'fixedSpacing', 'Period', 1);
% set(handles.figure1, 'DeleteFcn', {@DeleteFcn, t})
% start(t)
guidata(hObject, handles);
% UIWAIT makes Sketchy wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Sketchy_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


function timercallback(obj, event,handles)
global mydrawing pause_time
global Drawing Drawing0 constant
global indx;                             %序号数组传给全局变量indx
global labelname

% disp('222');
rgb_img = getframe(handles.drawingboard);
Drawing = rgb2gray(rgb_img.cdata);

if mydrawing==0
    pause_time = pause_time + 1;
end
Sum = sum(sum(Drawing));
if mydrawing==0 && Drawing0 ~= Sum && (pause_time >= 1) && Sum ~= constant 
    [ind , labelnames] = SearchImage(rgb_img.cdata);
%     disp('2222222222222');
    indx = ind;
    labelname = labelnames;
    set(handles.label1,'String',labelname{1});
    set(handles.label2,'String',labelname{2});
    set(handles.label3,'String',labelname{3});
    Updataimage(handles,2)
    Drawing0  = sum(sum(Drawing));
    pause_time = 0;
end

function DeleteFcn(hObject, eventdata, t)
stop(t);


% --- Executes on button press in switchbutton.
function switchbutton_Callback(hObject, eventdata, handles)
% hObject    handle to switchbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global switch_flag Pattern
if Pattern == 0
    set(handles.switchbutton,'String','橡皮檫');
    set(handles.clearbutton,'String','清空画板');
    switch_flag = 0;
    Pattern = Pattern + 1;
end
if Pattern == 1
    switch_flag = ~switch_flag;
    if switch_flag == 1
        set(handles.switchbutton,'String','画笔'); %当前状态是橡皮檫状态
    end
    if switch_flag == 0
        set(handles.switchbutton,'String','橡皮檫'); %当前状态是画笔状态
    end
end


% Hint: get(hObject,'Value') returns toggle state of switchbutton


% --- Executes on button press in previouspage.
function previouspage_Callback(hObject, eventdata, handles)
% hObject    handle to previouspage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pagenum
if pagenum ~= 1
    Updataimage(handles,0)
elseif pagenum == 1
    helpdlg('已经是第一页了','提示');
end

% --- Executes on button press in nextpage.
function nextpage_Callback(hObject, eventdata, handles)
% hObject    handle to nextpage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indx
global pagenum

if pagenum <= ceil(length(indx)/12)
    Updataimage(handles,1)
else
    helpdlg('已经是最后一页了','提示');
end

% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Drawing Drawing0 Pattern width height
if Pattern == 0
    filename = OnFileOpen();
    im = imread(filename);  
    if isempty(im)
        return
    end
    %axes(findobj('tag','drawingboard'));          
    axes(handles.drawingboard);
    im = imresize(im,[width height]);
    imshow(im);
    timercallback(hObject,eventdata,handles)
end
if Pattern == 1
    cla(handles.drawingboard);
    Drawing0  = sum(sum(Drawing));

end

% --- Executes during object creation, after setting all properties.
function drawingboard_CreateFcn(hObject, eventdata, handles)
% hObject    handle to drawingboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate drawingboard


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% print(2);




% --- Executes on mouse press over axes background.
function drawingboard_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to drawingboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% OpSet = 'off' ;
% CurPosShow(OpSet)
global mydrawing x0 y0
global init_x init_y width height
global switch_flag Pattern

global ButtonDown
if strcmp(get(gcf, 'SelectionType'),'normal')
    ButtonDown = 1;
end
pt = get(handles.figure1,'CurrentPoint');    %获取当前点坐标
x = pt(1,1);
y = pt(1,2);
% set(handles.figure1,'WindowButtonMotionFcn',{@WindowButtonMotionFcn,handles}); %设置鼠标移动响应
if (x >= init_x && x<= (init_x + width)) && (y >= init_y && y <= (init_y + height)) && Pattern
    mydrawing = 1;
    draw_x = floor(x - init_x);
    draw_y = floor(y - init_y);
%         draw_x = (x - init_x);
%         draw_y = (y - init_y);
    x0 = draw_x;
    y0 = draw_y;
%     fprintf('x1=%f,y1=%f\n',draw_x,draw_y);
%     axes(handles.drawingboard);
%     axis([0,width,0,height]);
%     axis fill
%     hold on
    if switch_flag == 0
        axes(handles.drawingboard);
        plot(draw_x,draw_y,'k.','MarkerFaceColor','k');
    end
    if switch_flag == 1
        axes(handles.drawingboard);
        plot(draw_x,draw_y,'wo','MarkerFaceColor','w','MarkerSize',20);
    end
    % plot(handles.drawingboard,draw_x,draw_y,'k.','MarkerFaceColor','k','parent',handles.drawingboard);
    % Drawing(floor(x),floor(y)) = 0;
end
% disp('1');


function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp('2');

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mydrawing x0 y0
global init_x init_y width height
global ButtonDown Pattern
global switch_flag
% pt = get(handles.figure1,'CurrentPoint');
pt = get(gcf,'CurrentPoint');
x = pt(1,1);
y = pt(1,2);
if (x >= init_x && x<= (init_x + width)) && (y >= init_y && y <= (init_y + height)) && ButtonDown && Pattern 
        mydrawing = 1;
    draw_x = floor(x - init_x);
    draw_y = floor(y - init_y);
%         draw_x = (x - init_x);
%         draw_y = (y - init_y);
    
    % 当鼠标移动较快时，不会出现离散点。
    % 利用y=kx+b直线方程实现。
    x_gap = 0.1;    % 定义x方向增量
    y_gap = 0.1;    % 定义y方向增量
    if draw_x > x0
        step_x = x_gap;
    else
        step_x = -x_gap;
    end
    if draw_y > y0
        step_y = y_gap;
    else
        step_y = -y_gap;
    end
    % 定义x,y的变化范围和步长
    if abs(draw_x-x0) < 0.01        % 线平行于y轴，即斜率不存在时
        iy = y0:step_y:draw_y;
        ix = draw_x.*ones(1,size(iy,2));
    else
        ix = x0:step_x:draw_x ;    % 定义x的变化范围和步长
        % 当斜率存在，即k = (Y-InitialY)/(X-InitialX) ~= 0
        iy = (draw_y-y0)/(draw_x-x0).*(ix-x0)+y0;
    end
    
    if switch_flag == 0
        axes(handles.drawingboard);
        plot(draw_x,draw_y,'k.','MarkerFaceColor','k');
        plot(ix,iy,'k.','MarkerFaceColor','k')
    end
    if switch_flag == 1
        axes(handles.drawingboard);
        plot(draw_x,draw_y,'wo','MarkerFaceColor','w','MarkerSize',20);
        plot(ix,iy,'wo','MarkerFaceColor','w','MarkerSize',20);
    end
    %     plot(draw_x,draw_y,'k.','MarkerFaceColor','k','parent',handles.drawingboard);
    %     plot(ix,iy,'k.','MarkerFaceColor','k','parent',handles.drawingboard);
%     fprintf('x2=%f,y2=%f\n',draw_x,draw_y);
    % Drawing(floor(x),floor(y)) = 0;
    % Drawing(floor(ix),floor(iy)) = 0;
    x0 = draw_x;
    y0 = draw_y;
end
% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ButtonDown mydrawing Pattern
ButtonDown = 0;
mydrawing = 0;
if Pattern == 1
    timercallback(hObject,eventdata,handles)
end


function Updataimage(handles,flag)

global pagenum                         %全局变量浏览到第几页
global indx

k = 12;

if flag == 1
    if (pagenum+1)*12 > length(indx)
        k = (pagenum+1)*12 - length(indx);
    end
    pagenum = pagenum + 1;
end
if flag == 0
    pagenum = pagenum - 1;
end
if flag == 2
    pagenum = 1;
end


for i=1:1:k                             %共显示前12张
    index=indx(12*(pagenum-1) + i);  %找到第i张图片名
    p = [index{1},'.jpg'];
    image=imread(p);        %读出该张图片
    switch i
        case 1
            axes( handles.image1) ;imshow(image) ;
        case 2
            axes( handles.image2) ;imshow(image) ;
        case 3
            axes( handles.image3) ;imshow(image) ;
        case 4
            axes( handles.image4) ;imshow(image) ;
        case 5
            axes( handles.image5) ;imshow(image) ;
        case 6
            axes( handles.image6) ;imshow(image) ;
        case 7
            axes( handles.image7) ;imshow(image) ;
        case 8
            axes( handles.image8) ;imshow(image) ;
        case 9
            axes( handles.image9) ;imshow(image) ;
        case 10
            axes( handles.image10) ;imshow(image) ;
        case 11
            axes( handles.image11) ;imshow(image) ;
        case 12
            axes( handles.image12) ;imshow(image) ;
    end
    hold on
end

pagename=strcat('第 ',num2str(pagenum),' 页');
set(handles.pagenumber,'String',pagename);   %显示该文本上的文字


% --- Executes during object creation, after setting all properties.
function background_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject)
imshow('background1.png');
% Hint: place code in OpeningFcn to populate background
