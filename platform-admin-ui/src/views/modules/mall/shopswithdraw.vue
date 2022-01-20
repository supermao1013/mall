<template>
  <div class="mod-shopswithdraw">
    <el-form :inline="true" :model="searchForm" @keyup.enter.native="getDataList(1)">
      <el-form-item>
        <el-input v-model="searchForm.userName" placeholder="店铺管理员" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-input v-model="searchForm.mobile" placeholder="店铺手机号" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-input v-model="searchForm.shopsName" placeholder="店铺名称" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-select v-model="searchForm.applyStatus" clearable filterable placeholder="申请状态" class="width185">
          <el-option key="1" label="申请中" value="1"></el-option>
          <el-option key="2" label="提现成功" value="2"></el-option>
          <el-option key="3" label="已拒绝" value="3"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button @click="getDataList(1)">查询</el-button>
        <el-button v-if="isAuth('mall:shopswithdraw:save')" type="primary" @click="applyHandle()">新增</el-button>
        <!--<el-button v-if="isAuth('mall:shopswithdraw:update')" type="danger" @click="deleteHandle()"-->
        <!--:disabled="dataListSelections.length != 1">修改-->
        <!--</el-button>-->
      </el-form-item>
    </el-form>
    <el-table
      :data="dataList"
      border
      @selection-change="selectionChangeHandle"
      style="width: 100%;">
      <el-table-column
        type="selection"
        header-align="center"
        align="center"
        width="50">
      </el-table-column>
      <el-table-column
        prop="userName"
        header-align="center"
        align="center"
        label="店铺管理员">
      </el-table-column>
      <el-table-column
        prop="mobile"
        header-align="center"
        align="center"
        label="手机号">
      </el-table-column>
      <el-table-column
        prop="shopsSn"
        header-align="center"
        align="center"
        label="店铺编码">
      </el-table-column>
      <el-table-column
        prop="shopsName"
        header-align="center"
        align="center"
        label="店铺名称">
      </el-table-column>
      <el-table-column
        prop="applyTime"
        width="160"
        header-align="center"
        align="center"
        label="申请时间">
      </el-table-column>
      <el-table-column
        prop="applyMoney"
        header-align="center"
        align="center"
        label="申请金额">
      </el-table-column>
      <el-table-column
        prop="approver"
        header-align="center"
        align="center"
        label="审核人">
      </el-table-column>
      <el-table-column
        prop="approvalTime"
        width="160"
        header-align="center"
        align="center"
        label="审核时间">
      </el-table-column>
      <el-table-column
        prop="approvalRemark"
        header-align="center"
        align="center"
        label="审核备注">
      </el-table-column>
      <el-table-column
        prop="applyStatus"
        header-align="center"
        align="center"
        label="申请状态">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.applyStatus === 1" size="small" type="info">申请中</el-tag>
          <el-tag v-else-if="scope.row.applyStatus === 2" size="small" type="success">提现成功</el-tag>
          <el-tag v-else-if="scope.row.applyStatus === 3" size="small" type="warning">已拒绝</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        fixed="right"
        header-align="center"
        align="center"
        width="100"
        label="操作">
        <template slot-scope="scope">
          <el-button v-if="isAuth('mall:shopswithdraw:info')" type="text" size="small"
                     @click="showDetailHandle(scope.row.id)">查看
          </el-button>
          <el-button v-if="isAuth('mall:shopswithdraw:check')" type="text" size="small"
                     @click="checkHandle(scope.row.id)">审核
          </el-button>
        </template>
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
    <withdraw-apply v-if="applyVisible" ref="apply" @refreshDataList="getDataList"></withdraw-apply>
    <!-- 弹窗, 新增 / 修改 -->
    <withdraw-check v-if="checkVisible" ref="check" @refreshDataList="getDataList"></withdraw-check>
  </div>
</template>

<script>
import WithdrawApply from './shopswithdraw-apply'
import WithdrawCheck from './shopswithdraw-check'

export default {
  data () {
    return {
      searchForm: {
        userName: '',
        mobile: '',
        userSn: '',
        applyStatus: '1'
      },
      dataList: [],
      pageIndex: 1,
      pageSize: 10,
      totalPage: 0,
      dataListSelections: [],
      applyVisible: false,
      checkVisible: false
    }
  },
  components: {
    WithdrawApply,
    WithdrawCheck
  },
  activated () {
    this.getDataList()
  },
  methods: {
    // 获取数据列表
    getDataList (page) {
      if (page) {
        this.pageIndex = page
      }
      this.$http({
        url: '/mall/shopswithdraw/list',
        method: 'get',
        params: {
          'page': this.pageIndex,
          'limit': this.pageSize,
          'userName': this.searchForm.userName,
          'mobile': this.searchForm.mobile,
          'userSn': this.searchForm.userSn,
          'applyStatus': this.searchForm.applyStatus

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
    },
    // 多选
    selectionChangeHandle (val) {
      this.dataListSelections = val
    },
    // 新增 / 修改
    applyHandle (id) {
      this.applyVisible = true
      this.$nextTick(() => {
        this.$refs.apply.applyWithdrawInit(id)
      })
    },
    // 查看 / 审核
    checkHandle (id) {
      this.checkVisible = true
      this.$nextTick(() => {
        this.$refs.check.init(id, false)
      })
    },
    showDetailHandle (id) {
      this.checkVisible = true
      this.$nextTick(() => {
        this.$refs.check.init(id, true)
      })
    }
  }
}
</script>
