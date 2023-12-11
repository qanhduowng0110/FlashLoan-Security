# FlashLoan-Security
# smart contract vulrebilities analysis
#Flash Loan là gì?
Flash Loan là hình thức cho vay nhanh với hai đặc điểm khác biệt với borrow và lending thông thường là:
+ Không yêu cầu tài sản đảm bảo (collateral)
+ Các khoản vay cần phải được vay và hoàn trả trong cùng 1 giao dịch (transaction)

Các khoản vay thường được trả về Pool theo cách sử dụng function safetransfer/ transfer hoặc safetranferFrom/transferFrom

# Tuy nhiên ở một số bên cho vay lại sử dụng cách tính:
if (poolBalance + fee > ERC20(token).balanceOf(address(this))){
            revert("TOKENS_NOT_RETURNED");
# Điều này vô tình tạo ra kẽ hở nếu Smart Contract của Pool đó có function deposit và withdraw dành cho user bình thường.
## Cách thức tấn công:
B1: gọi vào function FlashLoan số tiền bất kì mà Pool đang sở hữu

B2: trong fuction gọi lại về Smart Contract tấn công, gọi đến function deposit của Pool đó và nhập vào số tiền đã flashloan

B3: Kết thúc giao dịch flashloan với 1 khoản phí mà không bị revert (đã bypass điều kiện (poolBalance + fee > ERC20(token).balanceOf(address(this))))

B4: Gọi vào function withdraw để rút toàn bộ số tiền đã deposit ở B2
