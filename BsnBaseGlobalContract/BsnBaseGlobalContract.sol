pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;
import "./Table.sol";

contract BsnBaseGlobalContract {


    TableFactory tableFactory;
    string constant TABLE_NAME = "t_base";
    constructor() public {
        tableFactory = TableFactory(0x1001); //The fixed address is 0x1001 for TableFactory
        // the parameters of createTable are tableName,keyField,"vlaueFiled1,vlaueFiled2,vlaueFiled3,..."
        tableFactory.createTable(TABLE_NAME, "base_id", "base_key,base_value");
    }

    //select records
    function select(string base_id)
    public
    view
    returns (string[], int256[], string[])
    {
        Table table = tableFactory.openTable(TABLE_NAME);

        Condition condition = table.newCondition();

        Entries entries = table.select(base_id, condition);
        string[] memory base_id_bytes_list = new string[](
            uint256(entries.size())
        );
        int256[] memory base_key_list = new int256[](uint256(entries.size()));
        string[] memory base_value_bytes_list = new string[](
            uint256(entries.size())
        );

        for (int256 i = 0; i < entries.size(); ++i) {
            Entry entry = entries.get(i);

            base_id_bytes_list[uint256(i)] = entry.getString("base_id");
            base_key_list[uint256(i)] = entry.getInt("base_key");
            base_value_bytes_list[uint256(i)] = entry.getString("base_value");
        }

        return (base_id_bytes_list, base_key_list, base_value_bytes_list);
    }
    //insert records
    function insert(string base_id, int256 base_key, string base_value)
    public
    returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);

        Entry entry = table.newEntry();
        entry.set("base_id", base_id);
        entry.set("base_key", base_key);
        entry.set("base_value", base_value);

        int256 count = table.insert(base_id, entry);

        return count;
    }
    //update records
    function update(string base_id, int256 base_key, string base_value)
    public
    returns (int256)
    {
        Table table = tableFactory.openTable(TABLE_NAME);

        Entry entry = table.newEntry();
        entry.set("base_value", base_value);

        Condition condition = table.newCondition();
        condition.EQ("base_id", base_id);
        condition.EQ("base_key", base_key);

        int256 count = table.update(base_id, entry, condition);

        return count;
    }
    //remove records
    function remove(string base_id, int256 base_key) public returns (int256) {
        Table table = tableFactory.openTable(TABLE_NAME);

        Condition condition = table.newCondition();
        condition.EQ("base_id", base_id);
        condition.EQ("base_key", base_key);

        int256 count = table.remove(base_id, condition);

        return count;
    }
}
