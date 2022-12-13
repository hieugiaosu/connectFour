# connectFour
Đây là mô phỏng trò chơi connectFour sử dụng mars mips simulator và dùng tool Bitmap Display
# các vị trí trên bitmap display
    Tâm quả bóng đâu tiên trong bảng 7x7 là vị trí 272 byte so với base register
    Tâm của các vị trí tiếp theo trong bảng 7x7 có vị trí tương ứng là 272 + 512*m + 16*n với m là hàng, n là cột tương ứng (m từ 0 đến 6, n từ 0 đến 7)
    hàng đầu tiên là hàng dùng để trọn vị trí trước khi thả
    6 hàng tiếp theo là 6 hàng dùng cho trò chơi (bảng kích thước 6x7)
# Thiết lập thông số của bitmap display
    Unit width in Pixels: 8
    Unit Heigth in Pixels: 9
    Display width in Pixels: 256
    Display width in Pixels: 256
    Base address for display: 0x10040000 (heap)
    - Lý do sử dụng heap thay vì static data: Trong đoạn code có sử dụng dữ liệu phần data và dữ liệu đó có sự thay đổi
    theo luồng chạy của chương trình, vì thế nếu sử dụng base address là static data có thể gây ra lỗi không mong muốn
# hướng dẫn thao tác:
    Bắt đầu trò chơi, người chơi 1 sẽ là biểu tượng màu đỏ, người chơi 2 sẽ là biểu tượng màu xanh
    Nhấn phím 'a' hoặc 'd' để di chuyển đến nơi mình muốn thả
    Nhấn phím 's' hoặc bất kì phím kí tự nào khác ngoài 'a' hoặc 'd' để có thể thả bóng xuống cột đó
    Khi trò chơi kết thúc: bấm 'y' để chơi lại, bấm 'n' hoặc bất kì phím kí tự nào khác để kết thúc
    
