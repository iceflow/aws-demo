
# 目标
监测Direct Connect物理接口(Connection)和虚拟接口(VIF)状态

# 运行方式
```Bash
./sample.sh [profile_name]
```
Examples:
```Bash
./sample.sh test_profile
== Region cn-north-1 ===
=== Connections Status: ===
connectionName,connectionState
Connection1,available
Connection2,available
=== VIF status: ===
connectionId,virtualInterfaceName,virtualInterfaceState
dxcon-1234xxxx,vif_test_name1,available
dxcon-5678xxxx,vif_test_name2,available
```




# 状态说明
Connection 状态:
```Bash
    State of the connection.

        Ordering : The initial state of a hosted connection provisioned on an interconnect. The connection stays in the ordering state until the owner of the hosted connection confirms or declines the connection order.
        Requested : The initial state of a standard connection. The connection stays in the requested state until the Letter of Authorization (LOA) is sent to the customer.
        Pending : The connection has been approved, and is being initialized.
        Available : The network link is up, and the connection is ready for use.
        Down : The network link is down.
        Deleting : The connection is in the process of being deleted.
        Deleted : The connection has been deleted.
        Rejected : A hosted connection in the 'Ordering' state will enter the 'Rejected' state if it is deleted by the end customer.
```

VIF 状态:
```Bash
    State of the interconnect.

        Requested : The initial state of an interconnect. The interconnect stays in the requested state until the Letter of Authorization (LOA) is sent to the customer.
        Pending : The interconnect has been approved, and is being initialized.
        Available : The network link is up, and the interconnect is ready for use.
        Down : The network link is down.
        Deleting : The interconnect is in the process of being deleted.
        Deleted : The interconnect has been deleted.
```




# Ref: 
[AWS CLI Direct Connect 参考] (http://docs.aws.amazon.com/cli/latest/reference/directconnect/index.html)

