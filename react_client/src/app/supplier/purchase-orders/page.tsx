"use client";
import OrderView from "@/components/organisms/OrderModal";
import { OrderDeliveryContext } from "@/context/OrderDelivery/OrderDeliveryContext";
import { OrderPlacementContext } from "@/context/OrderPlacement/OrderPlacementContext";
// import AddOrder from "@/components/organisms/OrderAdd";
// import OrderEdit from "@/components/organisms/OrderEdit";

import { Table } from "antd";
import { format } from "date-fns";
import React, { useContext } from "react";

const Orders = () => {
  const { orders, loading, createDelivery } = useContext(
    OrderDeliveryContext
  ) as IOrderDeliveryContext;
  const tableData = orders.map((order) => {
    return {
      key: order.orderId,
      ...order,
    };
  });
  const columns = [
    {
      title: "Order ID",
      dataIndex: "orderId",
      key: "orderId",
    },
    {
      title: "Site Manager",
      dataIndex: "siteManager",
      key: "siteManager",
      render: (siteManager: IUser) => <>{siteManager.name}</>,
    },
    {
      title: "Site",
      dataIndex: "site",
      key: "site",
      render: (site: ISite) => <>{site.name}</>,
    },
    {
      title: "Total Price (Rs.)",
      dataIndex: "total",
      key: "total",
      render: (total: IOrder["total"]) => <>{total}</>,
    },
    {
      title: "Action",
      key: "action",
      render: (text: any, record: IOrder) => (
        <span>
          <OrderView record={record} delivery />
        </span>
      ),
    },
  ];
  return (
    <div className="flex flex-col gap-4">
      <div>{/* <AddOrder /> */}</div>
      <Table dataSource={tableData} columns={columns} loading={loading} />
    </div>
  );
};

export default Orders;
