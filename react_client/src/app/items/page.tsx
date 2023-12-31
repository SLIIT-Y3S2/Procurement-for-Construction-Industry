"use client";
import AddItem from "@/components/organisms/ItemAdd";
import ItemEdit from "@/components/organisms/ItemEdit";
import { ItemManagementContext } from "@/context/ItemManagement/ItemManagementContext";

import { Table } from "antd";
import { format } from "date-fns";
import React, { useContext } from "react";

const Items = () => {
  const { items, loading } = useContext(
    ItemManagementContext
  ) as IItemManagementContext;
  const tableData = items.map((item) => {
    return {
      key: item.itemId,
      ...item,
    };
  });
  return (
    <div className="flex flex-col gap-4">
      <div>
        <AddItem />
      </div>
      <Table
        dataSource={tableData}
        columns={columns}
        loading={loading}
        expandable={{
          expandedRowRender: (record) => (
            <div>
              <strong>Description:</strong> {record.description}
              <br />
              <strong>Supplier:</strong> {record.supplier?.name} -{" "}
              {record.supplier?.email}
              <br />
              <strong>Created At:</strong>{" "}
              {format(new Date(record.createdAt), "dd/MM/yyyy HH:mm:ss")}
              <br />
              <strong>Updated At:</strong>{" "}
              {format(new Date(record.updatedAt), "dd/MM/yyyy HH:mm:ss")}
            </div>
          ),
        }}
      />
    </div>
  );
};

export default Items;

const columns = [
  {
    title: "Item ID",
    dataIndex: "itemId",
    key: "itemId",
    // render: (text) => <a>{text}</a>,
  },
  {
    title: "Name",
    dataIndex: "name",
    key: "name",
    // render: (text) => <a>{text}</a>,
  },
  {
    title: "Price (Rs.)",
    dataIndex: "price",
    key: "price",
  },
  {
    title: "Supplier",
    dataIndex: ["supplier", "name"],
    key: "description",
  },
  {
    key: "action",
    title: "Action",
    render: (text: string, record: IItem) => <ItemEdit currentItem={record} />,
  },
];
