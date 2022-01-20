<template>
  <div class="mod-orderrefund">
    <el-form :inline="true" :model="searchForm" @keyup.enter.native="getDataList(1)">
      <el-form-item>
        <el-input v-model="searchForm.orderSn" placeholder="订单编码" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-input v-model="searchForm.userName" placeholder="申请用户" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-button @click="getDataList(1)">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      :data="dataList"
      border
      style="width: 100%;">
      <el-table-column
        type="selection"
        header-align="center"
        align="center"
        width="50">
      </el-table-column>
      <el-table-column
        prop="orderSn"
        header-align="center"
        align="center"
        label="订单编码">
      </el-table-column>
      <el-table-column
        prop="userId"
        header-align="center"
        align="center"
        label="申请用户">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="showUserDetails(scope.row.userId)">{{scope.row.nickname}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column
        prop="refundType"
        header-align="center"
        align="center"
        label="退款类型">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.refundType === 1" size="small" type="info">用户退款</el-tag>
          <el-tag v-else-if="scope.row.refundType === 2" size="small" type="success">系统退款</el-tag>
          <el-tag v-else-if="scope.row.refundType === 3" size="small" type="warning">售后退款</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="refundTime"
        header-align="center"
        align="center"
        label="退款时间">
        <template slot-scope="scope">
          <span>{{scope.row.refundTime}}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="refundMoney"
        header-align="center"
        align="center"
        label="退款金额">
      </el-table-column>
      <el-table-column
        prop="refundStatus"
        header-align="center"
        align="center"
        label="退款状态">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.refundStatus === 1" size="small" type="info">申请中</el-tag>
          <el-tag v-else-if="scope.row.refundStatus === 2" size="small" type="success">退款成功</el-tag>
          <el-tag v-else-if="scope.row.refundStatus === 3" size="small" type="warning">已拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="refundReason"
        header-align="center"
        align="center"
        label="退款原因">
      </el-table-column>
      <el-table-column
        prop="approver"
        header-align="center"
        align="center"
        label="审核人">
        <template slot-scope="scope">
          <span>{{transUser(scope.row.approver)}}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="approvalTime"
        header-align="center"
        align="center"
        label="审核时间">
        <template slot-scope="scope">
          <span>{{scope.row.approvalTime}}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="approvalRemark"
        header-align="center"
        align="center"
        label="审核备注">
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="sizeChangeHandle"
      @current-change="currentChangeHandle"
      :current-page="pageIndex"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      :total="totalPage"
      layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <!-- 弹窗, 新增 / 修改 -->
    <user-detail v-if="userDetailVisible" ref="userDetail"></user-detail>
  </div>
</template>

<script>
import UserDetail from './user-add-or-update'

export default {
  data () {
    return {
      searchForm: {
        orderSn: '',
        userName: ''
      },
      dataList: [],
      pageIndex: 1,
      pageSize: 10,
      totalPage: 0,
      userDetailVisible: false
    }
  },
  components: {
    UserDetail
  },
  activated () {
    this.getDataList()
  },
  methods: {
    // 查看会员详情
    showUserDetails (id) {
      this.userDetailVisible = true
      this.$nextTick(() => {
        this.$refs.userDetail.init(id, true)
      })
    },
    // 获取数据列表
    getDataList (page) {
      if (page) {
        this.pageIndex = page
      }
      this.$http({
        url: '/mall/orderrefund/list',
        method: 'get',
        params: {
          'page': this.pageIndex,
          'limit': this.pageSize,
          'orderSn': this.searchForm.orderSn,
          'userName': this.searchForm.userName
        }
      }).then(({data}) => {
        if (data && data.code === 0) {
          this.dataList = data.page.records
          this.totalPage = data.page.total
        } else {
          this.dataList = []
          this.totalPage = 0
        }
      })
    },
    // 每页数
    sizeChangeHandle (val) {
      this.pageSize = val
      this.pageIndex = 1
      this.getDataList()
    },
    // 当前页
    currentChangeHandle (val) {
      this.pageIndex = val
      this.getDataList()
    }
  }
}
</script>
