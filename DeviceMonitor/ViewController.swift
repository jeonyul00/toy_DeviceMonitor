//
//  ViewController.swift
//  DeviceMonitor
//
//  Created by 전율 on 11/26/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var observers = [NSObjectProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        UIDevice.current.isBatteryMonitoringEnabled = true
        var observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            let indexPath = IndexPath(row: 3, section: 0)
            (self?.view.subviews.first as? UITableView)?.reloadRows(at: [indexPath], with: .automatic)
        })
        observers.append(observer)
        
        observer = NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            let indexPath = IndexPath(row: 5, section: 0)
            (self?.view.subviews.first as? UITableView)?.reloadRows(at: [indexPath], with: .automatic)
        })
        observers.append(observer)
        
        observer = NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            let indexPath = IndexPath(row: 6, section: 0)
            (self?.view.subviews.first as? UITableView)?.reloadRows(at: [indexPath], with: .automatic)
        })
        observers.append(observer)
    }
    
    deinit {
        
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}


extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "디바이스 이름"
            cell.detailTextLabel?.text = UIDevice.current.name
        case 1:
            cell.textLabel?.text = "OS"
            cell.detailTextLabel?.text = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        case 2:
            cell.textLabel?.text = "디바이스 타입"
            switch UIDevice.current.userInterfaceIdiom {
            case .unspecified:
                cell.detailTextLabel?.text = "알 수 없음"
            case .phone:
                cell.detailTextLabel?.text = "아이폰"
            case .pad:
                cell.detailTextLabel?.text = "아이패드"
            case .tv:
                cell.detailTextLabel?.text = "애플티비"
            case .carPlay:
                cell.detailTextLabel?.text = "카플레이"
            case .mac:
                cell.detailTextLabel?.text = "맥"
            case .vision:
                cell.detailTextLabel?.text = "비전프로"
            @unknown default:
                fatalError()
            }
        case 3:
            cell.textLabel?.text = "디바이스 방향"
            switch UIDevice.current.orientation {
            case .unknown:
                cell.detailTextLabel?.text = "알 수 없음"
            case .portrait:
                cell.detailTextLabel?.text = "세로 (카메라 위치: 위)"
            case .portraitUpsideDown:
                cell.detailTextLabel?.text = "세로 (카메라 위치: 아래)"
            case .landscapeLeft:
                cell.detailTextLabel?.text = "가로 (카메라 위치: 왼쪽)"
            case .landscapeRight:
                cell.detailTextLabel?.text = "가로 (카메라 위치: 오른쪽)"
            case .faceUp:
                cell.detailTextLabel?.text = "평면 (카메라 위치: 하늘)"
            case .faceDown:
                cell.detailTextLabel?.text = "평면 (카메라 위치: 바닥)"
            @unknown default:
                fatalError()
            }
        case 4:
            cell.textLabel?.text = "배터리 모니터링"
            cell.detailTextLabel?.text = UIDevice.current.isBatteryMonitoringEnabled ? "활성" : "비활성"
        case 5:
            cell.textLabel?.text = "배터리 레벨"
            if UIDevice.current.isBatteryMonitoringEnabled {
                cell.detailTextLabel?.text = "\(Int(UIDevice.current.batteryLevel * 100))%"
            } else {
                cell.detailTextLabel?.text = "-"
            }
            
        case 6:
            cell.textLabel?.text = "충전 상태"
            if UIDevice.current.isBatteryMonitoringEnabled {
                switch UIDevice.current.batteryState {
                case .unknown:
                    cell.detailTextLabel?.text = "알 수 없음"
                case .unplugged:
                    cell.detailTextLabel?.text = "연결되지 않음"
                case .charging:
                    cell.detailTextLabel?.text = "충전중"
                case .full:
                    cell.detailTextLabel?.text = "충전완료"
                @unknown default:
                    fatalError()
                }
            } else {
                cell.detailTextLabel?.text = "-"
            }
        default:
            break
        }
        return cell
    }
    
}
