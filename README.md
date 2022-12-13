# connectFour
Đây là mô phỏng trò chơi connectFour sử dụng mars mips simulator và dùng tool Bitmap Display
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
    
