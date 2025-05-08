import SwiftUI

struct ContentView: View {
    @EnvironmentObject var syncManager: SyncManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .tag(0)
            
            ComplianceListView()
                .tabItem {
                    Label("Compliance", systemImage: "checkmark.shield")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .overlay(
            Group {
                if syncManager.isSyncing {
                    ProgressView("Syncing...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
        )
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Compliance Overview")) {
                    ComplianceSummaryCard()
                    ViolationTrendCard()
                }
                
                Section(header: Text("Recent Activities")) {
                    ForEach(0..<5) { _ in
                        ActivityRow()
                    }
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct ComplianceSummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Overall Compliance")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("95%")
                        .font(.system(size: 36, weight: .bold))
                    Text("Compliant")
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                CircularProgressView(progress: 0.95)
                    .frame(width: 60, height: 60)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                .foregroundColor(.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
    }
}

struct ViolationTrendCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Violation Trends")
                .font(.headline)
            
            // Placeholder for chart
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay(
                    Text("Chart Placeholder")
                        .foregroundColor(.gray)
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ActivityRow: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading) {
                Text("Policy Check Completed")
                    .font(.subheadline)
                Text("2 hours ago")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ComplianceListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { _ in
                    ComplianceItemRow()
                }
            }
            .navigationTitle("Compliance")
        }
    }
}

struct ComplianceItemRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Policy Name")
                    .font(.headline)
                Text("Last checked: 2 hours ago")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var syncManager: SyncManager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sync")) {
                    Button(action: {
                        Task {
                            await syncManager.syncWithServer()
                        }
                    }) {
                        HStack {
                            Text("Sync Now")
                            Spacer()
                            if syncManager.isSyncing {
                                ProgressView()
                            }
                        }
                    }
                    
                    if let lastSync = syncManager.lastSyncDate {
                        HStack {
                            Text("Last Sync")
                            Spacer()
                            Text(lastSync, style: .time)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
} 